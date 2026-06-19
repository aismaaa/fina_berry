<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::with('items.menu')->orderBy('created_at', 'desc')->get();

        return response()->json($orders->map(fn (Order $order) => $this->formatOrder($order)));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'customerName' => 'required|string|max:255',
            'tableNumber' => 'nullable|string|max:50',
            'paymentMethod' => 'required|string|max:100',
            'total' => 'required|numeric|min:0',
            'items' => 'required|array|min:1',
            'items.*.menu_id' => 'required',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.price' => 'required|numeric|min:0',
        ]);

        try {
            $order = DB::transaction(function () use ($validated) {
                $order = Order::create([
                    'customer_name' => $validated['customerName'],
                    'table_number' => $validated['tableNumber'] ?? null,
                    'payment_method' => $validated['paymentMethod'],
                    'total' => $validated['total'],
                    'status' => 'pending',
                    'payment_status' => 'pending',
                    'midtrans_order_id' => null,
                ]);

                foreach ($validated['items'] as $itemData) {
                    $menuId = intval($itemData['menu_id']);
                    $menu = Menu::where('id', $menuId)->lockForUpdate()->first();

                    if (!$menu) {
                        throw new \Exception("Menu item with id {$menuId} not found");
                    }

                    $qtyRequested = intval($itemData['quantity']);
                    if ($menu->quantity > 0 && $menu->quantity < $qtyRequested) {
                        throw new \Exception("Insufficient stock for menu id {$menuId}");
                    }

                    OrderItem::create([
                        'order_id' => $order->id,
                        'menu_id' => $menu->id,
                        'quantity' => $qtyRequested,
                        'price' => $itemData['price'],
                    ]);

                    if ($menu->quantity > 0) {
                        $menu->quantity = max(0, $menu->quantity - $qtyRequested);
                        $menu->is_available = $menu->quantity > 0;
                        $menu->save();
                    }

                }

                return $order;
            });

            $order->load('items.menu');
            $response = $this->formatOrder($order);

            // Generate Midtrans Snap Token
            \Midtrans\Config::$serverKey = config('midtrans.server_key') ?: env('MIDTRANS_SERVER_KEY');
            \Midtrans\Config::$isProduction = config('midtrans.is_production');
            \Midtrans\Config::$isSanitized = config('midtrans.is_sanitized');
            \Midtrans\Config::$is3ds = config('midtrans.is_3ds');

            $params = array(
                'transaction_details' => array(
                    'order_id' => 'ORDER-' . $order->id . '-' . time(),
                    'gross_amount' => $order->total,
                ),
                'customer_details' => array(
                    'first_name' => $order->customer_name,
                )
            );

            try {
                if (\Midtrans\Config::$serverKey) {
                    $snapResponse = \Midtrans\Snap::createTransaction($params);
                    $response['snap_token'] = $snapResponse->token;
                    $response['redirect_url'] = $snapResponse->redirect_url;
                }
            } catch (\Exception $e) {
                // Ignore if midtrans fails, or log it
                $response['midtrans_error'] = $e->getMessage();
            }

            return response()->json($response, 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Failed to create order',
                'details' => $e->getMessage(),
            ], 400);
        }
    }

    public function updateStatus(Request $request, $id)
    {
        $validated = $request->validate([
            'status' => 'required|string|in:pending,processing,completed,cancelled',
        ]);

        $order = Order::find($id);
        if (!$order) {
            return response()->json(['error' => 'Order not found'], 404);
        }

        $order->status = $validated['status'];
        $order->save();
        $order->load('items.menu');

        return response()->json($this->formatOrder($order));
    }

    private function formatOrder(Order $order): array
    {
        return [
            'id' => $order->id,
            'customerName' => $order->customer_name,
            'tableNumber' => $order->table_number,
            'paymentMethod' => $order->payment_method,
            'total' => $order->total,
            'status' => $order->status,
            'paymentStatus' => $order->payment_status,
            'midtransOrderId' => $order->midtrans_order_id,
            'date' => $order->created_at?->toIso8601String(),
            'items' => $order->items->map(fn (OrderItem $item) => [
                'quantity' => $item->quantity,
                'price' => $item->price,
                'item' => [
                    'id' => $item->menu->id,
                    'name' => $item->menu->name,
                    'description' => $item->menu->description,
                    'price' => $item->menu->price,
                    'imageUrl' => $item->menu->image_url,
                    'category' => $item->menu->category,
                    'isAvailable' => $item->menu->is_available,
                ],
            ])->toArray(),
        ];
    }
}
