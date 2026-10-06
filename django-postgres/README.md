# Django + PostgreSQL

A plain Django project wired to PostgreSQL. Both run in Docker on a shared
bridge network, so Django finds the database at the hostname `db`.

## You'll need

- WSL 2
- Docker Desktop with WSL integration on, or Docker Engine inside WSL
- `docker compose version` should print something

Keep the project somewhere under your Linux home folder (like `~/projects`),
not `/mnt/c`. Auto reload is much more reliable that way.

## Run it

```bash
cp .env.example .env
docker compose up --build
```

Then open http://localhost:8000/api/health. If you see this, you're set:

```json
{"status": "ok", "database": "connected"}
```

Migrations run every time the web container starts, so the admin is ready at
http://localhost:8000/admin once you create a user.

## Commands you'll use a lot

```bash
# admin user
docker compose exec web python manage.py createsuperuser

# new app
docker compose exec web python manage.py startapp blog

# migrations
docker compose exec web python manage.py makemigrations
docker compose exec web python manage.py migrate

# database shell
docker compose exec db psql -U app_user -d app_db

# logs
docker compose logs -f web

# stop
docker compose down

# stop and delete the database
docker compose down -v
```

Files created from inside the container (like a new app) end up owned by
root. If your editor won't save them, run:

```bash
sudo chown -R $USER:$USER .
```

## Layout

```
.
├── config/              settings, urls, wsgi, asgi
├── manage.py
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── .env.example
```

## Good to know

- Added a package to `requirements.txt`? Rebuild with `docker compose up --build`.
- Postgres is also published on `localhost:5432` so you can use DBeaver,
  pgAdmin or similar. If that port is taken, change the first `5432` in
  `docker-compose.yml`.
- Set a real `DJANGO_SECRET_KEY` and `DJANGO_DEBUG=0` before this goes
  anywhere other than your machine.
