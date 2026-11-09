<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => [
                ['id' => 1, 'name' => 'Ayu', 'email' => 'ayu@example.com'],
                ['id' => 2, 'name' => 'Bima', 'email' => 'bima@example.com'],
                ['id' => 3, 'name' => 'Citra', 'email' => 'citra@example.com'],
            ],
        ]);
    }
}
