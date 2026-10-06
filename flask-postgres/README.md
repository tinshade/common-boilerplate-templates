# Flask + PostgreSQL

A Flask app using the app factory pattern, Flask-SQLAlchemy and PostgreSQL.
Both run in Docker on a shared bridge network, and Flask reaches the database
at the hostname `db`.

## You'll need

- WSL 2
- Docker Desktop with WSL integration on, or Docker Engine inside WSL

Keep the project under your Linux home folder (like `~/projects`), not
`/mnt/c`, so the debug reloader notices your edits.

## Run it

```bash
cp .env.example .env
docker compose up --build
```

Open http://localhost:5000/api/health. You should get:

```json
{"database": "connected", "status": "ok"}
```

## Commands you'll use a lot

```bash
# logs
docker compose logs -f web

# Flask shell with the app loaded
docker compose exec web flask --app app shell

# database shell
docker compose exec db psql -U app_user -d app_db

# stop
docker compose down

# stop and delete the database
docker compose down -v
```

## Layout

```
.
├── app/
│   ├── __init__.py      create_app(), config, CORS
│   ├── extensions.py    the shared db object
│   └── routes.py        API routes under /api
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── .env.example
```

## Where to go next

- Add models in `app/models.py` using `db.Model`.
- Add more blueprints and register them in `create_app()`.
- For migrations, add `Flask-Migrate` to requirements and rebuild.
- If you point a frontend at this API, set its API URL to
  `http://localhost:5000` (the frontends default to port 8000).
- Postgres is published on `localhost:5432` for GUI clients. Change the first
  `5432` in `docker-compose.yml` if the port is taken.
