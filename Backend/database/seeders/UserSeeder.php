<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\User::updateOrCreate(
            ['email' => 'admin@finaberry.com'],
            [
                'name' => 'Admin Fina Berry',
                'password' => \Illuminate\Support\Facades\Hash::make('password'),
                'role' => 'admin',
            ],
        );

        \App\Models\User::updateOrCreate(
            ['email' => 'kasir@finaberry.com'],
            [
                'name' => 'Kasir Fina Berry',
                'password' => \Illuminate\Support\Facades\Hash::make('password'),
                'role' => 'kasir',
            ],
        );
    }
}
