# app.py
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        firstname = request.form.get('firstname')
        lastname = request.form.get('lastname')
        return f"Hello, {firstname} {lastname}!"
    return render_template('index.html')

if __name__ == "__main__":
    app.run(debug=True)
