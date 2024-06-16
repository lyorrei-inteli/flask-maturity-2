import requests as http_request
from flask import Blueprint, abort, jsonify, render_template, request, make_response
from flask_jwt_extended import create_access_token, jwt_required, set_access_cookies

from database.database import db
from database.models import User
import logging

logger = logging.getLogger("root")

api_blueprint = Blueprint("api", __name__)


def create_token(username, password):
    # Query your database for username and password
    user = User.query.filter_by(email=username, password=password).first()
    if user is None:
        raise Exception("Bad username or password")

    # create a new token with the user id inside
    access_token = create_access_token(identity=user.id)
    return {"token": access_token, "user_id": user.id}


@api_blueprint.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@api_blueprint.route("/users", methods=["GET"])
def get_users():
    logger.info("Get users request")
    users = User.query.all()
    return_users = []
    for user in users:
        return_users.append(user.serialize())
    return jsonify(return_users)


@api_blueprint.route("/users/<int:id>", methods=["GET"])
def get_user(id):
    logger.info("Get user request")
    user = User.query.get(id)
    if user is None:
        return abort(404)
    return jsonify(user.serialize())


@api_blueprint.route("/users", methods=["POST"])
def create_user():
    logger.info("Create user request")

    data = request.json
    user = User(name=data["name"], email=data["email"], password=data["password"])
    db.session.add(user)
    db.session.commit()
    return jsonify(user.serialize())


@api_blueprint.route("/users/<int:id>", methods=["PUT"])
def update_user(id):
    logger.info("Update user request")
    data = request.json
    user = User.query.get(id)
    if user is None:
        return abort(404)
    user.name = data["name"]
    user.email = data["email"]
    user.password = data["password"]
    db.session.commit()
    return jsonify(user.serialize())


@api_blueprint.route("/users/<int:id>", methods=["DELETE"])
def delete_user(id):
    logger.info("Delete user request")
    user = User.query.get(id)
    if user is None:
        return abort(404)
    db.session.delete(user)
    db.session.commit()
    return jsonify(user.serialize())


@api_blueprint.route("/users/login", methods=["POST"])
def login():
    logger.info("Login request")
    data = request.json

    try:
        token_data = create_token(data["username"], data["password"])
        token = token_data.get("token")
    except Exception as e:
        return abort(500)
    response = jsonify({"message": "Login Successful"})
    set_access_cookies(response, token)
    return response


@api_blueprint.route("/user-login", methods=["GET"])
def user_login():
    return render_template("login.html")


@api_blueprint.route("/user-register", methods=["GET"])
def user_register():
    return render_template("register.html")


@api_blueprint.route("/content", methods=["GET"])
@jwt_required()
def content():
    return render_template("content.html")
