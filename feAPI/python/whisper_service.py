from flask import Flask, request, jsonify
from flask_cors import CORS
import whisper
import os

app = Flask(__name__)
CORS(app)  # cho phép tất cả các domain truy cập, bạn có thể cấu hình chi tiết hơn nếu cần

model = whisper.load_model("small")

@app.route('/transcribe', methods=['POST'])
def transcribe():
    audio = request.files['file']
    if not os.path.exists("temp"):
        os.makedirs("temp")
    filepath = os.path.join("temp", audio.filename)
    audio.save(filepath)

    result = model.transcribe(filepath, language="en")
    os.remove(filepath)

    return jsonify({'text': result['text']})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
