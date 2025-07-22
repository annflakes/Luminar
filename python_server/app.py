from flask import Flask, request, jsonify
from flask_cors import CORS
from colorthief import ColorThief
import os

app = Flask(__name__)  # <-- MAKE SURE THIS LINE EXISTS!
CORS(app)

UPLOAD_FOLDER = "uploads"
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route("/detect_color", methods=["GET", "POST"])
def detect_color():
    if request.method == "GET":
        return jsonify({"message": "Send a POST request with an image file to detect color."})

    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files["image"]
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    try:
        color_thief = ColorThief(file_path)
        dominant_color = color_thief.get_color(quality=1)
        hex_color = "#{:02x}{:02x}{:02x}".format(*dominant_color)

        color_name = get_color_name(dominant_color)

        return jsonify({"color_name": color_name, "rgb": hex_color})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

def get_color_name(rgb):
    predefined_colors = {
        (255, 0, 0): "Red",
        (0, 255, 0): "Green",
        (0, 0, 255): "Blue",
        (255, 255, 0): "Yellow",
        (0, 255, 255): "Cyan",
        (255, 0, 255): "Magenta",
        (0, 0, 0): "Black",
        (255, 255, 255): "White",
        (128, 128, 128): "Gray",
    }
    return predefined_colors.get(rgb, "Unknown Color")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
