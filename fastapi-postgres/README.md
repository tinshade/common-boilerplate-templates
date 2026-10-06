# FastAPI + PostgreSQL

A small FastAPI app using SQLAlchemy 2 and PostgreSQL. Both run in Docker on a
shared bridge network, and the API reaches the database at the hostname `db`.

## You'll need

- WSL 2
- Docker Desktop with WSL integration on, or Docker Engine inside WSL

Keep the project under your Linux home folder (like `~/projects`), not
`/mnt/c`, so `--reload` picks up your changes.

## Run it

```bash
cp .env.example .env
docker compose up --build
```

Check these:

- http://localhost:8000/api/health should return `{"status": "ok", "database": "connected"}`
- http://localhost:8000/docs has the interactive API docs

## Commands you'll use a lot

```bash
# logs
docker compose logs -f api

# database shell
docker compose exec db psql -U app_user -d app_db

# shell inside the API container
docker compose exec api bash

# stop
docker compose down

# stop and delete the database
docker compose down -v
```

## Layout

```
.
├── app/
│   ├── main.py          app, CORS and routes
│   └── database.py      engine, session and Base for your models
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── .env.example
```

## Where to go next

- Put your models in `app/models.py` and inherit from `Base`.
- Use `db: Session = Depends(get_db)` in any route that needs the database.
- When you need migrations, add Alembic:
  `pip install alembic` in requirements, rebuild, then
  `docker compose exec api alembic init migrations`.
- Postgres is published on `localhost:5432` for GUI clients. Change the first
  `5432` in `docker-compose.yml` if the port is taken.
