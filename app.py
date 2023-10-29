from flask import Flask, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        firstname = request.form.get('firstname')
        lastname = request.form.get('lastname')
        return f'Hello {firstname} {lastname}!'
    return '''
        <form method="post">
            First Name: <input type="text" name="firstname">
            Last Name: <input type="text" name="lastname">
            <input type="submit" value="Submit">
        </form>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0')
