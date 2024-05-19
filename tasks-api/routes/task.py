import requests as http_request
from flask import Blueprint, jsonify, render_template, request, make_response
from flask_jwt_extended import create_access_token, jwt_required, set_access_cookies

from database.database import db
from database.models import Task

api_blueprint = Blueprint("task_api", __name__)

@api_blueprint.route("/tasks", methods=["GET"])
def get_tasks():
    tasks = Task.query.all()
    return_tasks = []
    for task in tasks:
        return_tasks.append(task.serialize())
    return jsonify(return_tasks[::-1])


@api_blueprint.route("/tasks/<int:id>", methods=["GET"])
def get_task(id):
    task = task.query.get(id)
    return jsonify(task.serialize())


@api_blueprint.route("/tasks", methods=["POST"])
def create_task():
    data = request.json
    task = Task(text=data["text"], status=data["status"])
    db.session.add(task)
    db.session.commit()
    return jsonify(task.serialize())


@api_blueprint.route("/tasks/<int:id>", methods=["PUT"])
def update_task(id):
    data = request.json
    task = Task.query.get(id)

    if 'text' in data:
        task.text = data['text']
    if 'status' in data:
        task.status = data['status']
    
    db.session.commit()
    return jsonify(task.serialize())


@api_blueprint.route("/tasks/<int:id>", methods=["DELETE"])
def delete_task(id):
    task = Task.query.get(id)
    db.session.delete(task)
    db.session.commit()
    return jsonify(task.serialize())