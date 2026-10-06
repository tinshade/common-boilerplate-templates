# Starter Templates

Six small starting points. Each folder is its own project with its own README.

| Folder             | Stack                              | Runs on                |
|--------------------|------------------------------------|------------------------|
| `django-postgres`  | Django + PostgreSQL in Docker      | http://localhost:8000  |
| `fastapi-postgres` | FastAPI + PostgreSQL in Docker     | http://localhost:8000  |
| `flask-postgres`   | Flask + PostgreSQL in Docker       | http://localhost:5000  |
| `nextjs-axios`     | Next.js with an axios client       | http://localhost:3000  |
| `react-axios`      | React (Vite) with an axios client  | http://localhost:5173  |
| `vite-axios`       | Vite, plain JavaScript, axios      | http://localhost:5173  |

Every backend exposes `GET /api/health`, which runs a quick query against the
database. Every frontend calls that same endpoint on load, so you can pair any
frontend with any backend and see right away whether they're talking.

The backends allow requests from `localhost:3000` and `localhost:5173` out of
the box.

## Before you start (WSL)

1. Keep your projects inside the Linux filesystem, for example `~/projects`.
   Working from `/mnt/c/...` is slow and breaks auto reload.
2. For the backends, install Docker Desktop and turn on WSL integration
   (Settings > Resources > WSL Integration), or install Docker Engine inside WSL.
3. For the frontends, install Node.js 22 with nvm:

   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
   source ~/.bashrc
   nvm install 22
   ```

Anything running in WSL on `localhost` opens fine in your Windows browser.
