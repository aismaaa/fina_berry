<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics
     */
    public function stats()
    {
        try {
            $stats = [
                'total_users' => User::count(),
                'total_roles' => Role::count(),
                'users_by_role' => User::with('roles')
                    ->get()
                    ->groupBy(function ($user) {
                        return $user->roles->first()?->name ?? 'No Role';
                    })
                    ->map(function ($users) {
                        return $users->count();
                    }),
                'recent_users' => User::latest()->take(10)->get(['id', 'name', 'email', 'created_at']),
            ];

            return response()->json(['stats' => $stats], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch stats: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Get dashboard analytics
     */
    public function analytics()
    {
        try {
            $analytics = [
                'users_per_day' => User::select(
                    DB::raw('DATE(created_at) as date'),
                    DB::raw('COUNT(*) as count')
                )
                    ->groupBy('date')
                    ->orderBy('date', 'desc')
                    ->take(30)
                    ->get(),
                'role_distribution' => Role::withCount('users')
                    ->get(['id', 'name'])
                    ->makeHidden('users_count')
                    ->each(function ($role) {
                        $role->user_count = $role->users_count;
                    }),
                'system_info' => [
                    'app_name' => config('app.name'),
                    'app_env' => config('app.env'),
                    'app_debug' => config('app.debug'),
                ],
            ];

            return response()->json(['analytics' => $analytics], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch analytics: ' . $e->getMessage()], 500);
        }
    }
}
