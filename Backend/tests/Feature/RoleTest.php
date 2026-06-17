<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class RoleTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    /**
     * Test can get all roles
     */
    public function test_can_get_all_roles(): void
    {
        $admin = User::factory()->create();
        $adminRole = Role::create(['name' => 'admin', 'description' => 'Administrator']);
        $admin->roles()->attach($adminRole);

        $token = $admin->createToken('auth_token')->plainTextToken;

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->getJson('/api/roles');

        $response->assertStatus(200)
            ->assertJsonStructure(['roles' => [['id', 'name', 'description']]]);
    }

    /**
     * Test can create a role
     */
    public function test_can_create_role(): void
    {
        $admin = User::factory()->create();
        $adminRole = Role::create(['name' => 'admin', 'description' => 'Administrator']);
        $admin->roles()->attach($adminRole);

        $token = $admin->createToken('auth_token')->plainTextToken;

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/roles', [
                'name' => 'moderator',
                'description' => 'Moderator Role',
            ]);

        $response->assertStatus(201)
            ->assertJson(['message' => 'Role created successfully']);

        $this->assertDatabaseHas('roles', ['name' => 'moderator']);
    }

    /**
     * Test can assign role to user
     */
    public function test_can_assign_role_to_user(): void
    {
        $admin = User::factory()->create();
        $user = User::factory()->create();
        $adminRole = Role::create(['name' => 'admin', 'description' => 'Administrator']);
        $userRole = Role::create(['name' => 'user', 'description' => 'Regular User']);
        $admin->roles()->attach($adminRole);

        $token = $admin->createToken('auth_token')->plainTextToken;

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/roles/assign', [
                'user_id' => $user->id,
                'role_id' => $userRole->id,
            ]);

        $response->assertStatus(200)
            ->assertJson(['message' => 'Role assigned to user successfully']);
    }
}
