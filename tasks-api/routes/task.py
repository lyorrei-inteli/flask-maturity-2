import base64
import logging
import numpy as np
import requests as http_request
from flask import Blueprint, jsonify, render_template, request, make_response, send_file
from flask_jwt_extended import create_access_token, jwt_required, set_access_cookies
import cv2
from database.database import db
from database.models import Task
from PIL import Image
from io import BytesIO

logger = logging.getLogger("root")
api_blueprint = Blueprint("task_api", __name__)


@api_blueprint.route("/tasks", methods=["GET"])
def get_tasks():
    logger.info("Get tasks request")
    tasks = Task.query.all()
    return_tasks = []
    for task in tasks:
        return_tasks.append(task.serialize())
    return jsonify(return_tasks[::-1])


@api_blueprint.route("/tasks/<int:id>", methods=["GET"])
def get_task(id):
    logger.info("Get task request")
    task = Task.query.get(id)
    if task is None:
        return "Task not found", 404
    return jsonify(task.serialize())


@api_blueprint.route("/tasks", methods=["POST"])
def create_task():
    logger.info("Create task request")
    data = request.json
    task = Task(text=data["text"], status=data["status"])
    db.session.add(task)
    db.session.commit()
    return jsonify(task.serialize())


@api_blueprint.route("/tasks/<int:id>", methods=["PUT"])
def update_task(id):
    logger.info("Update task request")
    data = request.json
    task = Task.query.get(id)
    if task is None:
        return "Task not found", 404
    if "text" in data:
        task.text = data["text"]
    if "status" in data:
        task.status = data["status"]

    db.session.commit()
    return jsonify(task.serialize())


@api_blueprint.route("/tasks/<int:id>", methods=["DELETE"])
def delete_task(id):
    logger.info("Delete task request")
    task = Task.query.get(id)
    if task is None:
        return "Task not found", 404
    db.session.delete(task)
    db.session.commit()
    return jsonify(task.serialize())


# Crie uma rota que recebe uma imagem, retira o fundo e retorna a imagem sem fundo


@api_blueprint.route("/tasks/image/remove-background", methods=["POST"])
def remove_background():
    logger.info("Remove background request")
    data = request.json
    if "image" not in data:
        return "Missing image data", 400

    # Decode the base64 image
    try:
        image_data = base64.b64decode(data["image"])
        image = Image.open(BytesIO(image_data))
        image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
    except Exception as e:
        return f"Invalid image data: {e}", 400

    # Initialize the mask
    mask = np.zeros(image.shape[:2], np.uint8)

    # Initialize background and foreground models
    bgdModel = np.zeros((1, 65), np.float64)
    fgdModel = np.zeros((1, 65), np.float64)

    # Define a rectangle around the foreground area
    # The values here are placeholders; you may need a way to set them dynamically
    rect = (50, 50, image.shape[1] - 100, image.shape[0] - 100)

    # Run the GrabCut algorithm
    cv2.grabCut(image, mask, rect, bgdModel, fgdModel, 5, cv2.GC_INIT_WITH_RECT)

    # Modify the mask to get the final result
    mask2 = np.where((mask == 2) | (mask == 0), 0, 1).astype("uint8")
    image = image * mask2[:, :, np.newaxis]

    # Convert back to RGB
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    img_pil = Image.fromarray(image)
    buffer = BytesIO()
    img_pil.save(buffer, format="PNG")
    buffer.seek(0)

    return send_file(buffer, mimetype="image/png")
