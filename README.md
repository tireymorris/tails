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

- User authentication (has_secure_password)
- Cookie sessions with 24-hour expiration
- Protected routes and dashboard
- Structured logging (DEBUG in dev, INFO in prod)

## Routes

**Web**: `/` `/auth/login` `/auth/register` `/auth/logout` `/dashboard`

## What's working?

- ✅ Clean separation of routes (auth, dashboard)
- ✅ Cookie-based sessions with 24-hour expiration
- ✅ Password hashing with bcrypt
- ✅ HttpOnly cookies (XSS protection)
- ✅ Secure cookies in production
- ✅ SameSite cookie attribute (Lax)
- ✅ Protected routes with auth checks
- ✅ Flash messages for user feedback
- ✅ Structured logging (DEBUG/INFO levels)
- ✅ Generic error messages (no user enumeration)

## What's not working?

Security gaps to fix before production:

- [ ] CSRF protection
- [ ] Rate limiting
- [ ] Secure default secrets
- [ ] Email verification
- [ ] Password reset
- [ ] Account lockout
- [ ] Refresh tokens (currently no way to extend session without re-login)

**Good for**: MVPs, internal tools, development  
**Not ready for**: Production apps with sensitive data

## License

MIT
