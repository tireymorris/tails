# Tails 🦊

A modern Ruby web framework featuring Falcon, Roda, ActiveRecord, JWT authentication, and Tailwind CSS.

## Stack

Falcon (server) • Roda (routing) • ActiveRecord (ORM) • JWT (auth) • ERB+Tailwind (UI)

## Setup

```bash
./bin/setup
```

Creates a demo user: `demo@example.com` / `password123`

## Run

```bash
./bin/dev
```

Visit `http://localhost:1234`

## Features

- User authentication (has_secure_password + JWT)
- Cookie sessions for web routes, JWT tokens for API
- Protected routes and dashboard
- Structured logging (DEBUG in dev, INFO in prod)

## Routes

**Web**: `/` `/auth/login` `/auth/register` `/auth/logout` `/dashboard`  
**API**: `/api/protected/profile` (JWT protected)

## License

MIT
