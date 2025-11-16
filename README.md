# Tails 🦊

A minimal web framework for Ruby developers who value simplicity over magic.

## Quick Start

```bash
git clone https://github.com/tireymorris/tails
cd tails
bin/setup
bin/dev
```

Visit `http://localhost:1234`

**Demo credentials**: `demo@example.com` / `password123`

## What's Included

- **Falcon** - High-performance web server
- **Roda** - Fast, tree-based routing
- **ActiveRecord** - Database ORM with SQLite
- **BCrypt** - Secure password hashing
- **ERB + Tailwind** - Templates and styling
- **Custom component library** - Reusable UI components

## Documentation

Start the app and visit the **Developer Guide** to see:

- Complete setup instructions
- Project architecture
- Style system with live examples
- Component library
- Code examples

The guide includes interactive examples of all components and utilities.

## Key Features

- ✅ User authentication with secure sessions
- ✅ CSRF protection on all forms
- ✅ Rate limiting (Rack::Attack)
- ✅ Structured logging
- ✅ Dark mode support
- ✅ Custom Tailwind component system
- ✅ One-command setup

## Project Structure

```
app/
  ├── app.rb              # Main Roda application
  ├── models/             # ActiveRecord models
  ├── routes/             # Route handlers
  ├── services/           # Business logic
  ├── helpers/            # Helper modules
  └── views/
      ├── components/     # Reusable ERB components
      ├── layouts/        # Layout templates
      └── pages/          # Page templates
```

## Environment Variables

The setup script automatically generates a secure `SESSION_SECRET`. Environment variables are configured in `.env`:

- `SESSION_SECRET` - Session encryption key (auto-generated)
- `RACK_ENV` - Environment (`development` or `production`)

## Production Considerations

Before deploying to production, consider adding:

- Email verification
- Password reset functionality
- Account lockout after failed attempts
- Security headers (CSP, X-Frame-Options, etc.)
- Background job processing (if needed)

## License

MIT
