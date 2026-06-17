<?php

namespace App\Http\Controllers;

use App\Models\Permission;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PermissionController extends Controller
{
    /**
     * Get all permissions
     */
    public function index()
    {
        try {
            $permissions = Permission::with('roles')->get();
            return response()->json(['permissions' => $permissions], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch permissions'], 500);
        }
    }

    /**
     * Create a new permission
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|unique:permissions,name',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $permission = Permission::create($request->only('name', 'description'));
            return response()->json(['message' => 'Permission created successfully', 'permission' => $permission], 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to create permission'], 500);
        }
    }

    /**
     * Get permission by ID
     */
    public function show($id)
    {
        try {
            $permission = Permission::with('roles')->find($id);
            if (!$permission) {
                return response()->json(['error' => 'Permission not found'], 404);
            }
            return response()->json(['permission' => $permission], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch permission'], 500);
        }
    }

    /**
     * Update permission
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|unique:permissions,name,' . $id,
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $permission = Permission::find($id);
            if (!$permission) {
                return response()->json(['error' => 'Permission not found'], 404);
            }
            $permission->update($request->only('name', 'description'));
            return response()->json(['message' => 'Permission updated successfully', 'permission' => $permission], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to update permission'], 500);
        }
    }

    /**
     * Delete permission
     */
    public function destroy($id)
    {
        try {
            $permission = Permission::find($id);
            if (!$permission) {
                return response()->json(['error' => 'Permission not found'], 404);
            }
            $permission->delete();
            return response()->json(['message' => 'Permission deleted successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to delete permission'], 500);
        }
    }

    /**
     * Assign permission to role
     */
    public function assignToRole(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'role_id' => 'required|exists:roles,id',
            'permission_id' => 'required|exists:permissions,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $permission = Permission::find($request->permission_id);
            $permission->roles()->attach($request->role_id);
            return response()->json(['message' => 'Permission assigned to role successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to assign permission'], 500);
        }
    }

    /**
     * Remove permission from role
     */
    public function removeFromRole(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'role_id' => 'required|exists:roles,id',
            'permission_id' => 'required|exists:permissions,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $permission = Permission::find($request->permission_id);
            $permission->roles()->detach($request->role_id);
            return response()->json(['message' => 'Permission removed from role successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to remove permission'], 500);
        }
    }
}
