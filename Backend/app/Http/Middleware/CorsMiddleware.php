<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CorsMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Allow requests from all origins in development
        $origin = $request->header('origin');
        
        // List of allowed origins for production
        $allowedOrigins = [
            'http://localhost:5173',
            'http://localhost:8000',
            'http://localhost:3000',
            'http://localhost:54507',
            'http://127.0.0.1:5173',
            'http://127.0.0.1:8000',
            'http://127.0.0.1:3000',
            'http://127.0.0.1:54507',
            'http://192.168.0.104:5173',
            'http://192.168.0.104:8000',
            'http://192.168.0.104:3000',
            'http://192.168.0.104:8080',
        ];

        // In development, allow any origin
        $isAllowed = app()->environment('local') || in_array($origin, $allowedOrigins);

        if ($isAllowed || !$origin) {
            $response = $next($request);
            if ($origin) {
                $response->header('Access-Control-Allow-Origin', $origin);
            }
            $response->header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD');
            $response->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, X-CSRF-Token');
            $response->header('Access-Control-Allow-Credentials', 'true');
            $response->header('Access-Control-Max-Age', '86400');
            return $response;
        }

        // Handle preflight requests
        if ($request->getMethod() === 'OPTIONS') {
            return response('', 200)
                ->header('Access-Control-Allow-Origin', $origin ?? '*')
                ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD')
                ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, X-CSRF-Token')
                ->header('Access-Control-Allow-Credentials', 'true')
                ->header('Access-Control-Max-Age', '86400');
        }

        return $next($request);
    }
}
