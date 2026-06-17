<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class MenuController extends Controller
{
    public function index()
    {
        $menus = Menu::all();

        return response()->json($menus->map(fn (Menu $menu) => $this->formatMenu($menu)));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'category' => 'required|string|max:100',
            'imageUrl' => 'nullable|string|max:1000',
            'image' => 'nullable|file|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'quantity' => 'nullable|integer|min:0',
        ]);

        $imageUrl = $validated['imageUrl'] ?? null;

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('menu_images', 'public');
            $imageUrl = Storage::url($path);
        }

        $menu = Menu::create([
            'name' => $validated['name'],
            'description' => $validated['description'] ?? '',
            'price' => $validated['price'],
            'category' => $validated['category'],
            'image_url' => $imageUrl,
            'quantity' => $validated['quantity'] ?? 0,
            'is_available' => ($validated['quantity'] ?? 0) > 0,
        ]);

        return response()->json($this->formatMenu($menu), 201);
    }

    public function update(Request $request, $id)
    {
        $menu = Menu::find($id);
        if (!$menu) {
            return response()->json(['error' => 'Menu item not found'], 404);
        }

        Log::debug('MenuController update payload', [
            'all' => $request->all(),
            'json' => $request->json()->all(),
            'headers' => $request->headers->all(),
            'content' => $request->getContent(),
        ]);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|required|numeric|min:0',
            'category' => 'sometimes|required|string|max:100',
            'imageUrl' => 'nullable|string|max:1000',
            'image' => 'nullable|file|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'isAvailable' => 'nullable|boolean',
            'quantity' => 'nullable|integer|min:0',
        ]);

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('menu_images', 'public');
            $validated['imageUrl'] = Storage::url($path);
        }

        $menu->name = $validated['name'] ?? $menu->name;
        $menu->description = $validated['description'] ?? $menu->description;
        $menu->price = $validated['price'] ?? $menu->price;
        $menu->category = $validated['category'] ?? $menu->category;
        $menu->image_url = $validated['imageUrl'] ?? $menu->image_url;
        if (array_key_exists('isAvailable', $validated)) {
            $menu->is_available = (bool)$validated['isAvailable'];
        }
        if (array_key_exists('quantity', $validated)) {
            $menu->quantity = $validated['quantity'];
            $menu->is_available = $menu->quantity > 0;
        }

        $menu->save();

        return response()->json($this->formatMenu($menu));
    }

    public function destroy($id)
    {
        $menu = Menu::find($id);
        if (!$menu) {
            return response()->json(['error' => 'Menu item not found'], 404);
        }

        try {
            // Remove related order items first to avoid foreign key constraint errors.
            $menu->orderItems()->delete();
            $menu->delete();

            return response()->json(['message' => 'Menu item and related order items deleted successfully'], 200);
        } catch (QueryException $e) {
            return response()->json([
                'error' => 'Menu item could not be deleted. It may be referenced by existing orders.',
                'details' => $e->getMessage(),
            ], 409);
        } catch (\Throwable $e) {
            return response()->json([
                'error' => 'Failed to delete menu item',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    private function formatMenu(Menu $menu): array
    {
        return [
            'id' => $menu->id,
            'name' => $menu->name,
            'description' => $menu->description,
            'price' => $menu->price,
            'imageUrl' => $menu->image_url,
            'category' => $menu->category,
            'isAvailable' => $menu->is_available,
            'quantity' => $menu->quantity,
        ];
    }
}
