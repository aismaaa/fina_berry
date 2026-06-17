<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ReportController extends Controller
{
    public function orders(Request $request)
    {
        $validated = $request->validate([
            'periode' => 'required|string',
            'tanggal_mulai' => 'nullable|date_format:Y-m-d',
            'tanggal_selesai' => 'nullable|date_format:Y-m-d',
        ]);

        $periode = $validated['periode'];
        $tanggalMulai = $validated['tanggal_mulai'];
        $tanggalSelesai = $validated['tanggal_selesai'];

        // Parse periode if tanggal_mulai/selesai not provided
        if (!$tanggalMulai || !$tanggalSelesai) {
            // Parse periode format: "2026-05" or "Mei 2026"
            list($tanggalMulai, $tanggalSelesai) = $this->parsePeriode($periode);
        }

        // Query orders within date range
        $orders = Order::whereBetween('created_at', [
            Carbon::parse($tanggalMulai)->startOfDay(),
            Carbon::parse($tanggalSelesai)->endOfDay(),
        ])->get();

        // Group by date and calculate totals
        $detail = [];
        foreach ($orders->groupBy(function ($order) {
            return $order->created_at->format('Y-m-d');
        }) as $tanggal => $dailyOrders) {
            $detail[] = [
                'tanggal' => $tanggal,
                'jumlah_pesanan' => $dailyOrders->count(),
                'total_harga' => $dailyOrders->sum('total'),
            ];
        }

        $totalPesanan = $orders->count();
        $totalPendapatan = $orders->sum('total');

        return response()->json([
            'status' => true,
            'data' => [
                'periode' => $periode,
                'total_pesanan' => $totalPesanan,
                'total_pendapatan' => $totalPendapatan,
                'detail' => $detail,
            ],
        ], 200);
    }

    public function export(Request $request)
    {
        $validated = $request->validate([
            'jenis' => 'required|string|in:pesanan,bulan_awal',
            'tanggal_mulai' => 'required|date_format:Y-m-d',
            'tanggal_selesai' => 'required|date_format:Y-m-d',
        ]);

        $jenis = $validated['jenis'];
        $tanggalMulai = $validated['tanggal_mulai'];
        $tanggalSelesai = $validated['tanggal_selesai'];

        // Query orders
        $orders = Order::whereBetween('created_at', [
            Carbon::parse($tanggalMulai)->startOfDay(),
            Carbon::parse($tanggalSelesai)->endOfDay(),
        ])->with('items.item')->get();

        // Group by date
        $detail = [];
        foreach ($orders->groupBy(function ($order) {
            return $order->created_at->format('Y-m-d');
        }) as $tanggal => $dailyOrders) {
            $detail[] = [
                'tanggal' => $tanggal,
                'jumlah_pesanan' => $dailyOrders->count(),
                'total_harga' => $dailyOrders->sum('total'),
            ];
        }

        $totalPesanan = $orders->count();
        $totalPendapatan = $orders->sum('total');

        // Generate PDF
        $pdf = \PDF::loadView('reports.sales', [
            'jenis' => $jenis,
            'tanggal_mulai' => $tanggalMulai,
            'tanggal_selesai' => $tanggalSelesai,
            'total_pesanan' => $totalPesanan,
            'total_pendapatan' => $totalPendapatan,
            'detail' => $detail,
            'orders' => $orders,
        ]);

        $filename = "laporan-penjualan-" . Carbon::now()->format('Y-m-d') . ".pdf";

        return $pdf->download($filename);
    }

    private function parsePeriode(string $periode): array
    {
        // Try format: YYYY-mm
        if (preg_match('/^(\d{4})-(\d{2})$/', $periode, $matches)) {
            $year = $matches[1];
            $month = $matches[2];
            $tanggalMulai = "$year-$month-01";
            $tanggalSelesai = Carbon::parse($tanggalMulai)->endOfMonth()->format('Y-m-d');
            return [$tanggalMulai, $tanggalSelesai];
        }

        // Try format: "Januari 2026" (Indonesian month names)
        $bulanIndonesia = [
            'Januari' => '01', 'Februari' => '02', 'Maret' => '03',
            'April' => '04', 'Mei' => '05', 'Juni' => '06',
            'Juli' => '07', 'Agustus' => '08', 'September' => '09',
            'Oktober' => '10', 'November' => '11', 'Desember' => '12',
        ];

        foreach ($bulanIndonesia as $bulan => $bulanNum) {
            if (stripos($periode, $bulan) !== false) {
                preg_match('/(\d{4})/', $periode, $yearMatch);
                if ($yearMatch) {
                    $year = $yearMatch[1];
                    $tanggalMulai = "$year-$bulanNum-01";
                    $tanggalSelesai = Carbon::parse($tanggalMulai)->endOfMonth()->format('Y-m-d');
                    return [$tanggalMulai, $tanggalSelesai];
                }
            }
        }

        // Default: current month
        $tanggalMulai = Carbon::now()->startOfMonth()->format('Y-m-d');
        $tanggalSelesai = Carbon::now()->endOfMonth()->format('Y-m-d');
        return [$tanggalMulai, $tanggalSelesai];
    }
}
