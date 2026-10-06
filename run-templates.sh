#!/bin/sh
set -eu

TEMPLATES="django-postgres fastapi-postgres flask-postgres nextjs-axios react-axios vite-axios"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

NAME=""

usage() {
  cat <<'EOF'
Usage: sh run-template.sh --name <template>

Sets up and starts one of the starter templates. This script should sit in
the same folder as the template folders.

Options:
  --name <template>   Template to run (required)
  --list              Show available templates
  --help              Show this message

Example:
  sh run-template.sh --name django-postgres
EOF
}

list() {
  echo "Available templates:"
  for t in $TEMPLATES; do
    echo "  $t"
  done
}

info() { echo "==> $*"; }
warn() { echo "Warning: $*" >&2; }
die() { echo "Error: $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
  case "$1" in
    --name)
      [ $# -ge 2 ] || die "--name needs a value"
      NAME=$2
      shift 2
      ;;
    --name=*)
      NAME=${1#*=}
      shift
      ;;
    --list)
      list
      exit 0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1 (try --help)"
      ;;
  esac
done

if [ -z "$NAME" ]; then
  usage
  echo
  list
  exit 1
fi

case " $TEMPLATES " in
  *" $NAME "*) ;;
  *)
    echo "Error: '$NAME' is not a known template." >&2
    echo >&2
    list >&2
    exit 1
    ;;
esac

PROJECT="$SCRIPT_DIR/$NAME"

[ -d "$PROJECT" ] || die "Folder '$NAME' not found next to this script ($SCRIPT_DIR)."

cd "$PROJECT"
info "Using $PROJECT"

case "$PROJECT" in
  /mnt/*)
    warn "This project is on the Windows drive. Things will be slow and auto reload may not work."
    warn "Move it somewhere under your Linux home folder, for example ~/projects."
    ;;
esac

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

setup_env() {
  target=$1
  if [ -f "$target" ]; then
    info "Using existing $target"
  elif [ -f .env.example ]; then
    cp .env.example "$target"
    info "Created $target from .env.example"
  fi
}

run_docker() {
  url=$1

  command -v docker >/dev/null 2>&1 \
    || die "Docker not found. Install Docker Desktop with WSL integration, or Docker Engine inside WSL."

  docker compose version >/dev/null 2>&1 \
    || die "Docker Compose v2 not found. 'docker compose version' should work."

  if ! docker info >/dev/null 2>&1; then
    echo "Error: Can't talk to Docker." >&2
    echo "  Make sure Docker Desktop is running (or run: sudo service docker start)." >&2
    echo "  If it says permission denied, run: sudo usermod -aG docker \$USER" >&2
    echo "  then close and reopen WSL." >&2
    exit 1
  fi

  setup_env .env

  info "Starting containers. Press Ctrl+C to stop."
  info "Once it's up, open $url"
  exec docker compose up --build
}

run_node() {
  env_file=$1
  url=$2

  command -v node >/dev/null 2>&1 || {
    echo "Error: Node.js not found. Install it with nvm:" >&2
    echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash" >&2
    echo "  source ~/.bashrc" >&2
    echo "  nvm install 22" >&2
    exit 1
  }
  command -v npm >/dev/null 2>&1 || die "npm not found. Reinstall Node with: nvm install 22"

  if ! node -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>20||(a===20&&b>=19)?0:1)'; then
    die "Node $(node -v) is too old. You need 20.19 or newer. Run: nvm install 22"
  fi

  setup_env "$env_file"

  if [ ! -d node_modules ]; then
    info "Installing packages"
    npm install
  else
    info "Packages already installed (delete node_modules to reinstall)"
  fi

  info "Starting dev server. Press Ctrl+C to stop."
  info "Open $url"
  exec npm run dev
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

case "$NAME" in
  django-postgres)  run_docker "http://localhost:8000/api/health" ;;
  fastapi-postgres) run_docker "http://localhost:8000/docs" ;;
  flask-postgres)   run_docker "http://localhost:5000/api/health" ;;
  nextjs-axios)     run_node ".env.local" "http://localhost:3000" ;;
  react-axios)      run_node ".env" "http://localhost:5173" ;;
  vite-axios)       run_node ".env" "http://localhost:5173" ;;
esac