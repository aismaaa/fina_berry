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

// Public routes
Route::post('/login', [\App\Http\Controllers\AuthController::class, 'login']);
Route::post('/register', [\App\Http\Controllers\AuthController::class, 'register']);

// Protected routes (require authentication)
Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [\App\Http\Controllers\AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Dashboard routes
    Route::prefix('dashboard')->group(function () {
        Route::get('/stats', [\App\Http\Controllers\DashboardController::class, 'stats']);
        Route::get('/analytics', [\App\Http\Controllers\DashboardController::class, 'analytics']);
    });

    // Role Management - Only for admin
    Route::middleware('role:admin')->group(function () {
        Route::resource('roles', \App\Http\Controllers\RoleController::class);
        Route::post('/roles/assign', [\App\Http\Controllers\RoleController::class, 'assignToUser']);
        Route::post('/roles/remove', [\App\Http\Controllers\RoleController::class, 'removeFromUser']);
    });

    // Permission Management - Only for admin
    Route::middleware('role:admin')->group(function () {
        Route::resource('permissions', \App\Http\Controllers\PermissionController::class);
        Route::post('/permissions/assign', [\App\Http\Controllers\PermissionController::class, 'assignToRole']);
        Route::post('/permissions/remove', [\App\Http\Controllers\PermissionController::class, 'removeFromRole']);
    });
});

