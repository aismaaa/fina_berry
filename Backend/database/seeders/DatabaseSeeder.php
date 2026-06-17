<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Seed roles and permissions
        $this->call([
            RoleSeeder::class,
            PermissionSeeder::class,
        ]);

        // User::factory(10)->create();

        // Only create test user if not exists
        $user = User::where('email', 'test@example.com')->first();
        if (!$user) {
            $user = User::factory()->create([
                'name' => 'Test User',
                'email' => 'test@example.com',
            ]);
        }

        // Assign admin role to test user if not already assigned
        $adminRole = \App\Models\Role::where('name', 'admin')->first();
        if ($adminRole && !$user->roles()->where('role_id', $adminRole->id)->exists()) {
            $user->roles()->attach($adminRole);
        }
    }
}
