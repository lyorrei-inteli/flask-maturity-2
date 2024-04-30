import sys

from flask import Flask
from flask_jwt_extended import JWTManager
from flask_swagger_ui import get_swaggerui_blueprint

from database.database import db
from flask_cors import CORS
from routes import user, task

app = Flask(__name__, template_folder="templates")

# CORS Configs
cors = CORS(app)
app.config["CORS_HEADERS"] = "Content-Type"
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///project.db"

# Database Configs
db.init_app(app)

# JWT Configs
app.config["JWT_SECRET_KEY"] = "goku-vs-vegeta"
app.config["JWT_TOKEN_LOCATION"] = ["cookies"]
jwt = JWTManager(app)

# Swagger Configs
SWAGGER_URL = "/api/docs"
API_URL = "/static/swagger.json"
swagger_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL, API_URL, config={"app_name": "Flask Application"}
)

# Registering Blueprints
app.register_blueprint(swagger_blueprint, url_prefix=SWAGGER_URL)
app.register_blueprint(user.api_blueprint)
app.register_blueprint(task.api_blueprint)

# Create the database if the command line argument is "create_db"
if len(sys.argv) > 1 and sys.argv[1] == "create_db":
    with app.app_context():
        db.create_all()
    print("Database created successfully")
    sys.exit(0)

# Run the application
if __name__ == "__main__":
    app.run(debug=True, threaded=True, host="0.0.0.0", port=5000)
