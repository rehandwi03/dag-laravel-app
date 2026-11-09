<?php

use App\Http\Controllers\HealthController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::get('/health', [HealthController::class, 'show']);
Route::get('/users', [UserController::class, 'index']);
