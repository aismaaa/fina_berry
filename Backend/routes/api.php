<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Public routes (Rute Publik)
Route::post('/login', [\App\Http\Controllers\AuthController::class, 'login']);
Route::post('/register', [\App\Http\Controllers\AuthController::class, 'register']);

// Menus
Route::get('/menus', [\App\Http\Controllers\MenuController::class, 'index']);
Route::post('/menus', [\App\Http\Controllers\MenuController::class, 'store']);
Route::patch('/menus/{id}', [\App\Http\Controllers\MenuController::class, 'update']);
Route::delete('/menus/{id}', [\App\Http\Controllers\MenuController::class, 'destroy']);

// Orders
Route::get('/orders', [\App\Http\Controllers\OrderController::class, 'index']);
Route::post('/orders', [\App\Http\Controllers\OrderController::class, 'store']);
Route::patch('/orders/{id}/status', [\App\Http\Controllers\OrderController::class, 'updateStatus']);
Route::delete('/orders/{id}', [\App\Http\Controllers\OrderController::class, 'destroy']);

// Reports
Route::get('/reports/orders', [\App\Http\Controllers\ReportController::class, 'orders']);
Route::get('/reports/export', [\App\Http\Controllers\ReportController::class, 'export']);

// Midtrans Payment & Webhook
Route::post('/midtrans/snap-token', [\App\Http\Controllers\MidtransController::class, 'createSnapToken']);
Route::post('/midtrans/notification', [\App\Http\Controllers\MidtransController::class, 'notification']);
Route::get('/midtrans/debug', [\App\Http\Controllers\MidtransController::class, 'debug']);
