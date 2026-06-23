<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('landing');
});

// Preview laporan penjualan (dengan data dummy)
Route::get('/sales', function () {
    return view('reports.sales', [
        'jenis'            => 'pesanan',
        'tanggal_mulai'    => now()->startOfMonth()->format('Y-m-d'),
        'tanggal_selesai'  => now()->format('Y-m-d'),
        'total_pesanan'    => 24,
        'total_pendapatan' => 3750000,
        'detail' => [
            ['tanggal' => now()->subDays(2)->format('Y-m-d'), 'jumlah_pesanan' => 8,  'total_harga' => 1200000],
            ['tanggal' => now()->subDays(1)->format('Y-m-d'), 'jumlah_pesanan' => 10, 'total_harga' => 1550000],
            ['tanggal' => now()->format('Y-m-d'),             'jumlah_pesanan' => 6,  'total_harga' => 1000000],
        ],
        'orders' => collect([]),
    ]);
});
