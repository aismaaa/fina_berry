<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class MidtransController extends Controller
{
    public function createSnapToken(Request $request)
    {
        $validated = $request->validate([
            'customerName' => 'required|string|max:255',
            'tableNumber' => 'nullable|string|max:50',
            'paymentMethod' => 'required|string|max:100',
            'total' => 'required|numeric|min:0',
            'items' => 'required|array|min:1',
            'items.*.menu_id' => 'required|integer|exists:menus,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.price' => 'required|numeric|min:0',
        ]);

        $serverKey = config('services.midtrans.server_key');
        $isProduction = config('services.midtrans.is_production');

        if (empty($serverKey)) {
            return $this->jsonCors(['error' => 'Midtrans server key is not configured'], 500);
        }

        // Only set Midtrans SDK config if the SDK is installed
        if (class_exists('\\Midtrans\\Config')) {
            \Midtrans\Config::$serverKey = $serverKey;
            \Midtrans\Config::$isProduction = $isProduction;
            \Midtrans\Config::$isSanitized = true;
            \Midtrans\Config::$is3ds = true;
        }

        $orderId = 'order-' . time() . '-' . rand(1000, 9999);
        $itemDetails = [];
        $grossAmount = 0;

        foreach ($validated['items'] as $item) {
            $price = round($item['price']);
            $quantity = intval($item['quantity']);
            $grossAmount += $price * $quantity;

            $menu = Menu::find($item['menu_id']);
            $itemDetails[] = [
                'id' => $item['menu_id'],
                'price' => $price,
                'quantity' => $quantity,
                'name' => $menu->name ?? 'Item ' . $item['menu_id'],
            ];
        }

        if (round($validated['total']) !== $grossAmount) {
            return $this->jsonCors([
                'error' => 'Total amount does not match the sum of item prices',
                'expectedTotal' => $grossAmount,
            ], 422);
        }

        $params = [
            'transaction_details' => [
                'order_id' => $orderId,
                'gross_amount' => $grossAmount,
            ],
            'item_details' => $itemDetails,
        ];

        $midtransResponseDebug = null;

        try {
            $clientKey = config('services.midtrans.client_key');
            $midtransResponseDebug = null;

            // If Midtrans SDK is available use it; otherwise call REST API directly.
            if (class_exists('\\Midtrans\\Snap')) {
                // Create Snap Redirect transaction so client can open the payment page (redirect_url)
                $transaction = \Midtrans\Snap::createTransaction($params);
                $redirectUrl = $transaction->redirect_url ?? null;
                $midtransResponseDebug = json_encode($transaction);
                Log::info('Midtrans SDK response: ' . $midtransResponseDebug);
            } else {
                // Fallback: call Midtrans Snap REST API directly using server key
                $endpoint = $isProduction
                    ? 'https://app.midtrans.com/snap/v1/transactions'
                    : 'https://app.sandbox.midtrans.com/snap/v1/transactions';

                $payload = json_encode($params);
                $auth = base64_encode($serverKey . ':');

                if (!function_exists('curl_init')) {
                    throw new \Exception('cURL extension is required for Midtrans fallback HTTP calls');
                }

                $ch = curl_init($endpoint);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_HTTPHEADER, [
                    'Accept: application/json',
                    'Content-Type: application/json',
                    'Authorization: Basic ' . $auth,
                ]);
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
                curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
                curl_setopt($ch, CURLOPT_TIMEOUT, 30);

                $responseBody = curl_exec($ch);
                $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                $curlErr = curl_error($ch);
                curl_close($ch);

                if ($curlErr) {
                    throw new \Exception('cURL error: ' . $curlErr);
                }

                $responseData = json_decode($responseBody, true);
                $midtransResponseDebug = $responseBody;
                Log::info('Midtrans HTTP response: ' . $midtransResponseDebug);
                if ($httpCode < 200 || $httpCode >= 300) {
                    $msg = is_array($responseData) ? json_encode($responseData) : $responseBody;
                    throw new \Exception('Midtrans API error: HTTP ' . $httpCode . ' - ' . $msg);
                }

                $redirectUrl = $responseData['redirect_url'] ?? null;
            }

            // If Midtrans didn't return a redirect_url, surface debug info
            if (empty($redirectUrl)) {
                $dbg = $midtransResponseDebug ?? 'no response';
                throw new \Exception('No redirect_url from Midtrans. response: ' . (is_string($dbg) ? $dbg : json_encode($dbg)));
            }

            $order = DB::transaction(function () use ($validated, $orderId, $grossAmount) {
                $order = Order::create([
                    'customer_name' => $validated['customerName'],
                    'table_number' => $validated['tableNumber'] ?? null,
                    'payment_method' => $validated['paymentMethod'],
                    'total' => $grossAmount,
                    'status' => 'pending',
                    'payment_status' => 'pending',
                    'midtrans_order_id' => $orderId,
                ]);

                foreach ($validated['items'] as $itemData) {
                    $menu = Menu::lockForUpdate()->find($itemData['menu_id']);
                    if (!$menu) {
                        throw new \Exception('Menu item not found.');
                    }

                    $quantity = intval($itemData['quantity']);
                    if ($menu->quantity > 0 && $menu->quantity < $quantity) {
                        throw new \Exception('Insufficient stock for menu item: ' . $menu->name);
                    }

                    OrderItem::create([
                        'order_id' => $order->id,
                        'menu_id' => $menu->id,
                        'quantity' => $quantity,
                        'price' => round($itemData['price']),
                    ]);

                    if ($menu->quantity > 0) {
                        $menu->quantity = max(0, $menu->quantity - $quantity);
                        $menu->is_available = $menu->quantity > 0;
                        $menu->save();
                    }

                }

                return $order;
            });

            return $this->jsonCors([
                'redirect_url' => $redirectUrl,
                'client_key' => $clientKey,
                'midtrans_order_id' => $orderId,
                'order_id' => $order->id,
            ], 200);
        } catch (\Exception $e) {
            Log::error('Midtrans snap token creation failed: ' . $e->getMessage());
            if (!empty($midtransResponseDebug)) {
                Log::error('Midtrans raw response: ' . $midtransResponseDebug);
            }
            $body = [
                'error' => 'Could not create Midtrans snap token',
                'details' => $e->getMessage(),
                'midtrans_response' => $midtransResponseDebug,
            ];
            return $this->jsonCors($body, 500);
        }
    }

    public function notification(Request $request)
    {
        $serverKey = config('services.midtrans.server_key');
        $isProduction = config('services.midtrans.is_production');

        if (empty($serverKey)) {
            return $this->jsonCors(['error' => 'Midtrans server key is not configured'], 500);
        }

        // Only set Midtrans SDK config if SDK is available
        if (class_exists('\\Midtrans\\Config')) {
            \Midtrans\Config::$serverKey = $serverKey;
            \Midtrans\Config::$isProduction = $isProduction;
            \Midtrans\Config::$isSanitized = true;
            \Midtrans\Config::$is3ds = true;
        }

        try {
            // If SDK available, use it to parse notification and verify signature.
            if (class_exists('\\Midtrans\\Notification')) {
                $notif = new \Midtrans\Notification();
                $transaction = $notif->transaction_status;
                $fraud = $notif->fraud_status;
                $midtransOrderId = $notif->order_id;
            } else {
                // Fallback: parse JSON payload directly (no verification)
                $payload = $request->getContent();
                $data = json_decode($payload, true) ?? [];
                $transaction = $data['transaction_status'] ?? ($data['latestTransactionStatus'] ?? ($data['status'] ?? null));
                $fraud = $data['fraud_status'] ?? ($data['fraudStatus'] ?? null);
                $midtransOrderId = $data['order_id'] ?? ($data['originalPartnerReferenceNo'] ?? ($data['partnerReferenceNo'] ?? null));
            }

            $order = Order::where('midtrans_order_id', $midtransOrderId)->first();
            if (!$order) {
                Log::warning('Midtrans notification received for unknown order id: ' . $midtransOrderId);
                return $this->jsonCors(['error' => 'Order not found'], 200);
            }

            if ($transaction === 'capture') {
                if ($fraud === 'challenge') {
                    $order->payment_status = 'challenge';
                    $order->status = 'processing';
                } elseif ($fraud === 'accept') {
                    $order->payment_status = 'paid';
                    $order->status = 'completed';
                }
            } elseif ($transaction === 'settlement') {
                $order->payment_status = 'paid';
                $order->status = 'completed';
            } elseif (in_array($transaction, ['cancel', 'deny', 'expire'], true)) {
                $order->payment_status = 'failed';
                $order->status = 'cancelled';
            } elseif ($transaction === 'pending') {
                $order->payment_status = 'pending';
                $order->status = 'pending';
            }

            $order->save();

            Log::info('Midtrans notification updated order ' . $order->id . ' status: ' . $transaction . ', fraud: ' . $fraud);

            return $this->jsonCors(['success' => true], 200);
        } catch (\Exception $e) {
            Log::error('Midtrans notification processing failed: ' . $e->getMessage());
            return $this->jsonCors(['error' => 'Failed to process notification', 'details' => $e->getMessage()], 500);
        }
    }

    private function jsonCors($body, $status = 200)
    {
        return response()->json($body, $status)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }

    /**
     * Debug endpoint: returns whether Midtrans config and SDK are available.
     */
    public function debug(Request $request)
    {
        $serverKey = config('services.midtrans.server_key');
        $clientKey = config('services.midtrans.client_key');
        $isProduction = config('services.midtrans.is_production');

        $serverKeyPresent = !empty($serverKey);
        $clientKeyPresent = !empty($clientKey);

        $snapClass = class_exists('\\Midtrans\\Snap');
        $configClass = class_exists('\\Midtrans\\Config');

        // Mask keys for safety
        $mask = function ($k) {
            if (empty($k)) return null;
            return substr($k, 0, 6) . '...' . substr($k, -4);
        };

        return response()->json([
            'server_key_present' => $serverKeyPresent,
            'client_key_present' => $clientKeyPresent,
            'server_key_masked' => $mask($serverKey),
            'client_key_masked' => $mask($clientKey),
            'is_production' => $isProduction,
            'midtrans_snap_class_exists' => $snapClass,
            'midtrans_config_class_exists' => $configClass,
        ]);
    }
}
