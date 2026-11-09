<?php

namespace Tests\Feature;

use Tests\TestCase;

class ApiTest extends TestCase
{
    public function test_the_health_endpoint_returns_ok(): void
    {
        $this->getJson('/api/health')
            ->assertOk()
            ->assertJsonPath('status', 'ok')
            ->assertJsonStructure(['status', 'service', 'timestamp']);
    }

    public function test_the_users_endpoint_returns_the_sample_collection(): void
    {
        $this->getJson('/api/users')
            ->assertOk()
            ->assertJsonCount(3, 'data')
            ->assertJsonPath('data.0.name', 'Ayu')
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'email'],
                ],
            ]);
    }

    public function test_unknown_api_routes_return_not_found(): void
    {
        $this->getJson('/api/unknown')->assertNotFound();
    }
}
