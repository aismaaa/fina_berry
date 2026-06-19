<?php

namespace Database\Seeders;

use App\Models\Menu;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Menu::firstOrCreate([
            'name' => 'Nasi Goreng Spesial',
        ], [
            'description' => 'Nasi goreng dengan telur, ayam, dan kerupuk.',
            'price' => 25000,
            'image_url' => 'https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=800&q=80',
            'category' => 'Makanan',
            'is_available' => true,
            'quantity' => 999,
        ]);

        Menu::firstOrCreate([
            'name' => 'Es Teh Manis',
        ], [
            'description' => 'Minuman es teh manis segar.',
            'price' => 8000,
            'image_url' => 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80',
            'category' => 'Minuman',
            'is_available' => true,
            'quantity' => 999,
        ]);
    }
}
