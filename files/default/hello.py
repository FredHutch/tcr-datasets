from flask import Flask

app = Flask(__name__)

@app.route('/hello')
def index():
    return "<span style='color:red'>hello world</span>"
