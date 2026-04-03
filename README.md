# Tails 🦊

[CI](https://github.com/tireymorris/tails/actions/workflows/ci.yml)

Tails is a small Ruby web app starter built for people who want clear code, fast iteration, and sane defaults without heavy framework magic.

## Philosophy

- Keep the stack minimal and explicit.
- Stay close to Rack/Roda primitives.
- Favor secure defaults and straightforward architecture.
- Optimize for readability over clever abstractions.

## What You Get

- Roda routing + Falcon server
- ActiveRecord + SQLite
- ERB + Tailwind UI setup
- Session auth with bcrypt
- CSRF protection and rate limiting
- RSpec, RuboCop, and CI checks
- Model generator and migrations workflow

## Quick Start

Requirements: Ruby 3.2+, Bundler

```bash
git clone https://github.com/tireymorris/tails
cd tails
bin/setup
bin/dev
```

Open `http://localhost:1234`  
Demo login: `demo@example.com` / `password123`

## Daily Usage

```bash
bin/dev
bundle exec rspec
rake lint
bin/generate model Post title:string
rake db:migrate
```

## Project Shape

- `app/` routes, models, helpers, views
- `config/` app config
- `db/` migrations and seeds
- `spec/` test suite
- `bin/` setup/dev/generator scripts

## Environment

- `SESSION_SECRET` session encryption key (generated in setup)
- `RACK_ENV` app environment (`development`, `production`)

