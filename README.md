# Ruby Web Application

A modern Ruby web application built with Falcon, Roda, ActiveRecord, and more.

## Tech Stack

- **Falcon** - High-performance web server
- **Roda** - Fast, simple routing tree web framework
- **ActiveRecord** - Database ORM
- **ActiveSupport** - Ruby utilities and extensions
- **Sorcery** - Authentication framework
- **JWT** - JSON Web Token authentication
- **Tailwind CSS** - Utility-first CSS framework

## Features

- User authentication with Sorcery
- Cookie-based sessions
- JWT token support for API endpoints
- Beautiful UI with Tailwind CSS
- Protected routes and API endpoints
- RESTful API structure

## Setup

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

### Development with Falcon:

```bash
bundle exec falcon serve
```

### Development with Rackup:

```bash
bundle exec rackup
```

The application will be available at `http://localhost:9292` (Falcon) or `http://localhost:9292` (Rackup).

## Project Structure

```
ruby_app/
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
