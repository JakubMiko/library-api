# Library API

API for library management - tracking books and borrowings.

## Tech Stack

- **Ruby 4.0 / Rails 8.1** - API-only mode
- **PostgreSQL 18** - database
- **Solid Queue** - background jobs (single database config)
- **dry-validation** - validation contracts (outside models)
- **jsonapi-serializer** - JSON:API response format
- **rswag** - OpenAPI/Swagger docs generated from tests

## Key Decisions

- **Validation in contracts** (`app/contracts/`) instead of models - easier testing, reusability, and keeping models lean
- **Soft delete for books** (`deleted_at`) - preserves borrowing history
- **5 borrowings limit** per reader - business rule in contract
- **Single database** for app and Solid Queue - simpler for dev/small deployments
- **Services only for complex logic** - simple CRUD actions stay in controllers, service objects used only for borrowing/returning (scheduling jobs, multiple validations)

## Local Setup

```bash
# Requirements: Ruby 4.0, PostgreSQL

bundle install
bin/rails db:prepare db:seed
bin/dev
```

API: http://localhost:3000/api/v1/books
Swagger: http://localhost:3000/api-docs

## Docker Compose

```bash
docker compose up --build
```

On first run it automatically:
- Creates database
- Runs migrations
- Seeds test data

API: http://localhost:3000/api/v1/books
Swagger: http://localhost:3000/api-docs

## Tests

```bash
bundle exec rspec
```

Testing convention:
- **Request specs** (rswag) - test main API paths and generate Swagger documentation
- **Service specs** - detailed business logic tests, also indirectly cover validators
- **Job specs** - test background job behavior

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/v1/books | List all books |
| GET | /api/v1/books/:id | Book details + borrowing history |
| POST | /api/v1/books | Add a book |
| DELETE | /api/v1/books/:id | Delete a book |
| POST | /api/v1/borrowings | Borrow a book |
| PATCH | /api/v1/borrowings/:id | Return a book |
