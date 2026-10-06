import os

from flask import Flask
from flask_cors import CORS

from app.extensions import db


def create_app():
    app = Flask(__name__)

    app.config["SECRET_KEY"] = os.environ.get("FLASK_SECRET_KEY", "change-me")
    app.config["SQLALCHEMY_DATABASE_URI"] = (
        f"postgresql+psycopg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}"
        f"@{os.environ.get('POSTGRES_HOST', 'db')}:{os.environ.get('POSTGRES_PORT', '5432')}"
        f"/{os.environ['POSTGRES_DB']}"
    )

    db.init_app(app)

    origins = [o for o in os.environ.get("CORS_ALLOWED_ORIGINS", "").split(",") if o]
    CORS(app, origins=origins, supports_credentials=True)

    from app.routes import bp

    app.register_blueprint(bp)

    return app
