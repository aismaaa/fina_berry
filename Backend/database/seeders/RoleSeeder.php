<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\Role::create([
            'name' => 'admin',
            'description' => 'Administrator with full access',
        ]);
        \App\Models\Role::create([
            'name' => 'manager',
            'description' => 'Manager with limited access',
        ]);
        \App\Models\Role::create([
            'name' => 'user',
            'description' => 'Regular user with basic access',
        ]);
    }
}
