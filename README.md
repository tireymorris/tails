# Tails 🦊

A modern Ruby web application built with Falcon, Roda, ActiveRecord, and more.

## Tech Stack

- **Falcon** - High-performance web server
- **Roda** - Fast, simple routing tree web framework
- **ActiveRecord** - Database ORM
- **ActiveModel** - Model layer with has_secure_password
- **ActiveSupport** - Ruby utilities and extensions
- **BCrypt** - Secure password hashing
- **JWT** - JSON Web Token authentication
- **Tailwind CSS** - Utility-first CSS framework (via CDN)

## Features

- User authentication with has_secure_password
- Cookie-based sessions
- JWT token support for API endpoints
- Beautiful UI with Tailwind CSS
- Protected routes and API endpoints
- RESTful API structure
- Structured logging with Ruby Logger (DEBUG level in development, INFO in production)

## Setup

### Quick Setup (Recommended):

```bash
./bin/setup
```

This automated script will install dependencies, create the database, run migrations, and seed demo data.

### Manual Setup:

1. Install dependencies:

```bash
bundle install
```

2. Set up environment variables:

```bash
cp .env.example .env
```

Edit `.env` and add your own secrets.

3. Create and migrate the database:

```bash
rake db:create
rake db:migrate
```

4. (Optional) Seed the database:

```bash
rake db:seed
```

This creates a demo user:

- Email: demo@example.com
- Password: password123

## Running the Application

### Quick Start (Recommended):

```bash
./bin/dev
```

This uses foreman to manage the application processes defined in `Procfile.dev`.

### Alternative Methods:

#### Development with Falcon:

```bash
bundle exec falcon serve
```

#### Development with Rackup:

```bash
bundle exec rackup
```

The application will be available at `http://localhost:1234` (or `http://localhost:9292` if running Falcon/Rackup directly).

## Logging

The application uses Ruby's built-in Logger with the following configuration:

- **Development**: DEBUG level - shows all logs including detailed authentication flow
- **Production**: INFO level - shows important events only (logins, registrations, errors)

Log format: `[YYYY-MM-DD HH:MM:SS] LEVEL: message`

Example logs:

```
[2025-11-14 14:22:01] DEBUG: Login attempt for email: user@example.com
[2025-11-14 14:22:01] DEBUG: User found: ID 1
[2025-11-14 14:22:01] DEBUG: Authentication result: success
[2025-11-14 14:22:01] INFO: User 1 (user@example.com) logged in successfully
```

## Project Structure

```
tails/
├── app/
│   ├── app.rb              # Main Roda application
│   ├── helpers/            # Helper modules
│   │   ├── auth_helper.rb
│   │   └── jwt_helper.rb
│   ├── models/             # ActiveRecord models
│   │   └── user.rb
│   └── views/              # ERB templates
│       ├── layout.erb
│       ├── home.erb
│       ├── auth/
│       │   ├── login.erb
│       │   └── register.erb
│       └── dashboard/
│           └── index.erb
├── config/
│   ├── environment.rb      # Environment setup
│   └── initializers/
│       └── sorcery.rb      # Sorcery configuration
├── db/
│   ├── migrate/            # Database migrations
│   └── seeds.rb            # Seed data
├── config.ru               # Rack configuration
├── Gemfile                 # Dependencies
└── Rakefile               # Rake tasks

```

## Available Routes

### Web Routes

- `GET /` - Home page
- `GET /auth/login` - Login page
- `POST /auth/login` - Process login
- `GET /auth/register` - Registration page
- `POST /auth/register` - Process registration
- `GET /auth/logout` - Logout
- `GET /dashboard` - User dashboard (protected)

### API Routes

- `GET /api/protected/profile` - Get user profile (JWT protected)

## Authentication

The application uses dual authentication:

1. **Cookie Sessions**: For web routes, traditional session-based authentication
2. **JWT Tokens**: For API routes, token-based authentication

When a user logs in:

- A session is created with their user ID
- A JWT token is generated and stored in an httpOnly cookie
- The JWT token can be used to authenticate API requests

## Database Commands

```bash
rake db:create      # Create database
rake db:migrate     # Run migrations
rake db:rollback    # Rollback last migration
rake db:reset       # Drop, create, and migrate
rake db:seed        # Load seed data
```

## Security Notes

- Change `SESSION_SECRET` and `JWT_SECRET` in production
- Use secure cookies (https) in production
- Keep dependencies updated
- Review and adjust Sorcery configuration as needed

## Development

The application uses:

- SQLite3 for the database (easy to swap for PostgreSQL/MySQL)
- ERB for templates
- Tailwind CSS via CDN (can be configured for production builds)

## License

MIT
