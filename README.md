# Sample Laravel REST API

A minimal Laravel REST API used as the sample workload for the CodeBuild/CodeDeploy pipeline in `task-2/`. It has no database dependency and no AWS integration, so builds stay fast and predictable.

This directory is a **separate Git repository** from the repository root.

## Endpoints

| Method | Path | Response |
|---|---|---|
| `GET` | `/api/health` | `{"status":"ok","service":"...","timestamp":"..."}` |
| `GET` | `/api/users` | Static collection of three sample users |

Both endpoints are public and return JSON. Laravel also exposes `GET /up` as a framework health check.

## Requirements

- PHP 8.2+ with `mbstring`, `xml`, `curl`, `sqlite3`, `zip`
- Composer 2
- Docker (optional, for building the deployment image)

## Local setup

```sh
cd app/rest
composer install
cp .env.example .env
php artisan key:generate
php artisan serve --host=127.0.0.1 --port=8000
```

Try it:

```sh
curl -sS http://127.0.0.1:8000/api/health
curl -sS http://127.0.0.1:8000/api/users
```

## Tests

```sh
php artisan test
```

`tests/Feature/ApiTest.php` covers the health endpoint, the sample collection, and unknown routes.

## Container build

The repository includes a production Dockerfile for the backend pipeline:

- `Dockerfile` — PHP 8.2 + Apache, installs production Composer dependencies, serves `public/`.
- `backend.apache.conf` — Apache virtual host with `DocumentRoot /var/www/html/public`.
- `.dockerignore` — keeps `.env`, `vendor`, tests, and local caches out of the image.

Build locally:

```sh
docker build -t laravel-rest-sample .
docker run --rm -p 8080:80 laravel-rest-sample
curl -sS http://127.0.0.1:8080/api/health
```

The image serves on container port 80 and does not bake in runtime configuration. Provide environment values at deploy time.

## Relationship to the CodeBuild pipeline

The backend CodeBuild project in `task-2/` expects:

- this repository as the GitHub source,
- `buildspec.yml` at the repository root (copy from `task-2/deploy/backend-buildspec.yml`),
- `appspec.yaml` and `scripts/` for CodeDeploy (copy from `task-2/deploy/`),
- the Dockerfile in this repository root.

The sample app itself has no Terraform or AWS credentials. CodeBuild builds and pushes the image, and CodeDeploy starts the container on the EC2 Auto Scaling Group.
