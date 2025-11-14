# Tails 🦊

A minimal web framework for Ruby developers who value simplicity over magic.

## Stack

**Server**: Falcon  
**Routing**: Roda  
**Database**: SQLite3 + ActiveRecord  
**Auth**: BCrypt + Rack::Session  
**Templates**: ERB  
**Styling**: Tailwind CSS

## Setup

1. Copy the environment file and generate a secure session secret:

```bash
cp env.example .env
```

2. Edit `.env` and set `SESSION_SECRET` to a long random string (64+ characters):

```bash
openssl rand -hex 64
```

3. Run setup:

```bash
./bin/setup
```

Creates a demo user: `demo@example.com` / `password123`

## Run

```bash
./bin/dev
```

Visit `http://localhost:1234`

## Environment Variables

- `SESSION_SECRET` (required): Long random string for session encryption (64+ chars)
- `RACK_ENV` (optional): `development` or `production` (default: `development`)

## Features

- User authentication (has_secure_password)
- Cookie sessions with 24-hour expiration
- Protected routes and dashboard
- Structured logging (DEBUG in dev, INFO in prod)

## Routes

**Web**: `/` `/auth/login` `/auth/register` `/auth/logout` `/dashboard`

## What's working?

- ✅ Clean route separation with helper modules
- ✅ BCrypt password hashing with 24-hour session expiration
- ✅ Secure cookies (HttpOnly + Secure + SameSite)
- ✅ SQLite3 + ActiveRecord with migrations
- ✅ One-command setup and dev server
- ✅ Structured logging and flash messages
- ✅ CSRF protection on all forms
- ✅ Rate limiting (login: 5/min, register: 3/5min)
- ✅ Required session secrets (no insecure defaults)
- ✅ Email format validation

## What's not working?

Security gaps to fix before production:

- [ ] Email verification
- [ ] Password reset
- [ ] Account lockout after failed attempts
- [ ] Refresh tokens (currently no way to extend session without re-login)
- [ ] Security headers (X-Frame-Options, CSP, etc.)

## License

MIT
