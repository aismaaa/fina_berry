<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class DashboardTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    /**
     * Test can get dashboard stats
     */
    public function test_can_get_dashboard_stats(): void
    {
        $token = 'test-token-123';
        $user = User::factory()->create(['api_token' => $token]);
        Role::create(['name' => 'user']);
        $user->roles()->attach(1);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->getJson('/api/dashboard/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'stats' => [
                    'total_users',
                    'total_roles',
                    'users_by_role',
                    'recent_users',
                ]
            ]);
    }

    /**
     * Test can get dashboard analytics
     */
    public function test_can_get_dashboard_analytics(): void
    {
        $token = 'test-token-456';
        $user = User::factory()->create(['api_token' => $token]);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->getJson('/api/dashboard/analytics');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'analytics' => [
                    'users_per_day',
                    'role_distribution',
                    'system_info',
                ]
            ]);
    }
}
