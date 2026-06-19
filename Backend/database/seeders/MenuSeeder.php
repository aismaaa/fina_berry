<?php

namespace Database\Seeders;

use App\Models\Menu;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Hapus data lama (dan order dummy terkait) agar bersih
        // KITA COMMENT AGAR TIDAK MENGHAPUS DATA DAN FOTO YANG SUDAH DIUPLOAD
        // DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        // DB::table('order_items')->truncate();
        // DB::table('orders')->truncate();
        // Menu::truncate();
        // DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $menus = [
            // Makanan - Bakso & Soto dll
            ['name' => 'Bakso Daging Sapi', 'price' => 15000, 'category' => 'Makanan'],
            ['name' => 'Bakso Krewedan', 'price' => 22000, 'category' => 'Makanan'],
            ['name' => 'Bakso Keju', 'price' => 17000, 'category' => 'Makanan'],
            ['name' => 'Soto Ayam', 'price' => 10000, 'category' => 'Makanan'],
            ['name' => 'Soto Ayam Komplit', 'price' => 20000, 'category' => 'Makanan'],
            ['name' => 'Soto Daging Sapi', 'price' => 23000, 'category' => 'Makanan'],
            ['name' => 'Soto Babat', 'price' => 20000, 'category' => 'Makanan'],
            ['name' => 'Nasi Goreng', 'price' => 15000, 'category' => 'Makanan'],
            ['name' => 'Sop Daging Sapi + Nasi', 'price' => 25000, 'category' => 'Makanan'],
            ['name' => 'Ca Kangkung', 'price' => 8000, 'category' => 'Makanan'],

            // Makanan - Paket Ayam & Ikan
            ['name' => 'Paket Ayam Goreng', 'price' => 15000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Bakar', 'price' => 15000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Goreng Penyet', 'price' => 16000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Bakar Penyet', 'price' => 16000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Goreng Kampung', 'price' => 25000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Bakar Kampung', 'price' => 27000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Goreng Kampung Penyet', 'price' => 27000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ayam Bakar Kampung Penyet', 'price' => 27000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ikan Mujair Goreng', 'price' => 20000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],
            ['name' => 'Paket Ikan Mujair Bakar', 'price' => 20000, 'category' => 'Makanan', 'desc' => 'Termasuk Nasi + Lauk + Lalap Sambal'],

            // Minuman
            ['name' => 'Teh Tawar', 'price' => 2000, 'category' => 'Minuman'],
            ['name' => 'Es Teh Tawar', 'price' => 3000, 'category' => 'Minuman'],
            ['name' => 'Teh Manis Anget', 'price' => 3000, 'category' => 'Minuman'],
            ['name' => 'Es Teh Manis', 'price' => 4000, 'category' => 'Minuman'],
            ['name' => 'Lemon Tea Anget', 'price' => 9000, 'category' => 'Minuman'],
            ['name' => 'Es Lemon Tea', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Jeruk Anget', 'price' => 4000, 'category' => 'Minuman'],
            ['name' => 'Es Jeruk', 'price' => 5000, 'category' => 'Minuman'],
            ['name' => 'Aneka Kopi', 'price' => 3000, 'category' => 'Minuman'],
            ['name' => 'Kopi Cappucino', 'price' => 5000, 'category' => 'Minuman'],
            ['name' => 'Es Kopi Cappucino', 'price' => 5000, 'category' => 'Minuman'],
            ['name' => 'Jahe Susu', 'price' => 3000, 'category' => 'Minuman'],
            ['name' => 'Soda Susu', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Wedang Jahe', 'price' => 7000, 'category' => 'Minuman'],

            // Minuman - Aneka Jus
            ['name' => 'Jus Strawberry', 'price' => 12000, 'category' => 'Minuman'],
            ['name' => 'Jus Melon', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Jus Jambu', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Jus Mangga', 'price' => 12000, 'category' => 'Minuman'],
            ['name' => 'Jus Jeruk', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Jus Buah Naga', 'price' => 10000, 'category' => 'Minuman'],
            ['name' => 'Jus Alpukat', 'price' => 12000, 'category' => 'Minuman'],

            // Cemilan
            ['name' => 'Mendoan', 'price' => 10000, 'category' => 'Cemilan', 'desc' => '1 Porsi'],
            ['name' => 'Tahu Brontak', 'price' => 10000, 'category' => 'Cemilan', 'desc' => '1 Porsi'],
            ['name' => 'Pisang Goreng', 'price' => 10000, 'category' => 'Cemilan', 'desc' => '1 Porsi'],
        ];

        foreach ($menus as $menu) {
            // Cek apakah menu sudah ada agar fotonya tidak tertimpa
            $existingMenu = Menu::where('name', $menu['name'])->first();
            if (!$existingMenu) {
                Menu::create([
                    'name' => $menu['name'],
                    'description' => $menu['desc'] ?? '',
                    'price' => $menu['price'],
                    'image_url' => '', // Kosong agar bisa diupload gambar nanti
                    'category' => $menu['category'],
                    'is_available' => true,
                    'quantity' => 100, // Default stok
                ]);
            }
        }
    }
}
