<?php

namespace App\Http\Controllers;

use App\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RoleController extends Controller
{
    /**
     * Get all roles
     */
    public function index()
    {
        try {
            $roles = Role::with('users', 'permissions')->get();
            return response()->json(['roles' => $roles], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch roles'], 500);
        }
    }

    /**
     * Create a new role
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|unique:roles,name',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $role = Role::create($request->only('name', 'description'));
            return response()->json(['message' => 'Role created successfully', 'role' => $role], 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to create role'], 500);
        }
    }

    /**
     * Get role by ID
     */
    public function show($id)
    {
        try {
            $role = Role::with('users', 'permissions')->find($id);
            if (!$role) {
                return response()->json(['error' => 'Role not found'], 404);
            }
            return response()->json(['role' => $role], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch role'], 500);
        }
    }

    /**
     * Update role
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|unique:roles,name,' . $id,
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $role = Role::find($id);
            if (!$role) {
                return response()->json(['error' => 'Role not found'], 404);
            }
            $role->update($request->only('name', 'description'));
            return response()->json(['message' => 'Role updated successfully', 'role' => $role], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to update role'], 500);
        }
    }

    /**
     * Delete role
     */
    public function destroy($id)
    {
        try {
            $role = Role::find($id);
            if (!$role) {
                return response()->json(['error' => 'Role not found'], 404);
            }
            $role->delete();
            return response()->json(['message' => 'Role deleted successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to delete role'], 500);
        }
    }

    /**
     * Assign role to user
     */
    public function assignToUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'role_id' => 'required|exists:roles,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $role = Role::find($request->role_id);
            $role->users()->attach($request->user_id);
            return response()->json(['message' => 'Role assigned to user successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to assign role'], 500);
        }
    }

    /**
     * Remove role from user
     */
    public function removeFromUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'role_id' => 'required|exists:roles,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $role = Role::find($request->role_id);
            $role->users()->detach($request->user_id);
            return response()->json(['message' => 'Role removed from user successfully'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to remove role'], 500);
        }
    }
}
