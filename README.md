# Tails 🦊

[![CI](https://github.com/tireymorris/tails/actions/workflows/ci.yml/badge.svg)](https://github.com/tireymorris/tails/actions/workflows/ci.yml)

A minimal web framework for Ruby developers who value simplicity over magic.

## Quick Start

### Prerequisites
- Ruby 3.2+
- Bundler

### Installation

```bash
git clone https://github.com/tireymorris/tails
cd tails
bin/setup
bin/dev
```

Visit `http://localhost:1234`

**Demo credentials**: `demo@example.com` / `password123`

### Development Workflow

After setup:

1. **Start development server**: `bin/dev`
2. **Run tests**: `bundle exec rspec`
3. **Run linting**: `rake lint` or `bundle exec rubocop`
4. **Generate models**: `bin/generate model ModelName field:type`
5. **Run migrations**: `rake db:migrate`

### Testing

Tests are written with RSpec. Run the full test suite:

```bash
bundle exec rspec
```

Run specific test files:

```bash
bundle exec rspec spec/models/user_spec.rb
```

## What's Included

- **Falcon** - High-performance web server
- **Roda** - Fast, tree-based routing
- **ActiveRecord** - Database ORM with SQLite
- **BCrypt** - Secure password hashing
- **ERB + Tailwind** - Templates and styling
- **Custom component library** - Reusable UI components

## Key Features

- ✅ User authentication with secure sessions
- ✅ CSRF protection on all forms
- ✅ Rate limiting (Rack::Attack)
- ✅ Structured logging
- ✅ Dark mode support
- ✅ Custom Tailwind component system
- ✅ One-command setup
- ✅ Model generator for rapid development

## API Documentation

### Authentication Routes

#### GET /auth/login
Displays the login form.

**Response**: HTML page with login form

#### POST /auth/login
Authenticates a user with email and password.

**Parameters**:
- `email` (string): User email address
- `password` (string): User password

**Response**: Redirects to dashboard on success, back to login with error on failure

#### GET /auth/register
Displays the registration form.

**Response**: HTML page with registration form

#### POST /auth/register
Creates a new user account.

**Parameters**:
- `email` (string): User email address
- `password` (string): User password (min 6 characters)
- `password_confirmation` (string): Password confirmation

**Response**: Redirects to dashboard on success, back to register with errors on failure

#### GET /auth/logout
Logs out the current user by clearing the session.

**Response**: Redirects to root with success message

### Models

#### User Model
Represents authenticated users in the system.

**Attributes**:
- `id` (integer): Primary key
- `email` (string): Unique email address
- `password_digest` (string): BCrypt hashed password
- `created_at` (datetime): Record creation timestamp
- `updated_at` (datetime): Record update timestamp

**Validations**:
- Email: presence, uniqueness, valid format
- Password: minimum 6 characters (on creation/update)

**Methods**:
- `authenticate(password)`: Verifies password against stored hash

## Code Quality

### Linting

This project uses RuboCop for code style and linting.

To run linting:

```bash
rake lint
# or
bundle exec rubocop
```

To auto-fix offenses:

```bash
bundle exec rubocop --autocorrect
```

The `.rubocop.yml` file contains the configuration rules.

### Continuous Integration

This project uses GitHub Actions for continuous integration. The CI pipeline runs on every push to the `main` branch and on every pull request.

The CI pipeline performs the following checks:

- **Tests**: Runs the full RSpec test suite with `bundle exec rspec`
- **Linting**: Runs RuboCop code style checks with `bundle exec rubocop`
- **Security Audit**: Runs Bundler Audit to check for vulnerabilities in dependencies with `bundle audit`

The CI configuration is defined in `.github/workflows/ci.yml`. All checks must pass before code can be merged.

## Architecture Overview

Tails follows a modular, MVC-inspired architecture built on the Roda framework:

- **Routing Layer**: Uses Roda's tree-based routing with multi-route plugin for organized route handling
- **Controller Layer**: Routes are defined directly in Roda route blocks, with helpers for shared functionality
- **Model Layer**: ActiveRecord models with built-in validations and associations
- **View Layer**: ERB templates with a custom component system and Tailwind CSS for styling
- **Middleware Stack**: Rack-based with CSRF protection, rate limiting, and session management
- **Database**: SQLite with ActiveRecord migrations for schema management

Key architectural decisions:
- Minimal dependencies for fast boot times and low memory usage
- Plugin-based extensibility through Roda's plugin system
- Secure-by-default with CSRF protection and secure password hashing
- Developer-friendly with one-command setup and generators

## Project Structure

```
app/
  ├── app.rb              # Main Roda application with routing and plugins
  ├── models/             # ActiveRecord models with validations
  ├── routes/             # Route handlers organized by feature
  ├── helpers/            # Shared utility modules (e.g., CurrentUser)
  └── views/
      ├── components/     # Reusable ERB components with Tailwind
      ├── layouts/        # Layout templates for consistent UI
      └── pages/          # Page-specific templates
config/                   # Application configuration
db/                       # Database migrations and seeds
spec/                     # RSpec tests for models and routes
bin/                      # Executable scripts for setup and development
```

## Generating Models

Create new models with migrations using the generator:

```bash
bin/generate model Post title:string content:text user:references
rake db:migrate
```

This creates:
- Migration file: `db/migrate/00X_create_posts.rb`
- Model file: `app/models/post.rb` (with validations and associations)

Supported field types: `string`, `text`, `integer`, `float`, `decimal`, `boolean`, `date`, `datetime`, `time`, `references`

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

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on how to get started.

## License

MIT
