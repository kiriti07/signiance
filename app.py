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

@app.route('/.well-known/acme-challenge/<challenge>')
def letsencrypt_challenge(challenge):
    challenge_response = {
        "X0edjFmRNGCuH_ZB_XpW_6St-qiJRjtoIwvEaXnN_Co": "X0edjFmRNGCuH_ZB_XpW_6St-qiJRjtoIwvEaXnN_Co.74JPPShE0vhxdFLOR9S1cpkYBCM4EeIXnGYAc_dSjfI"
    }
    return challenge_response.get(challenge, 'Challenge not found')

if __name__ == '__main__':
    app.run(host='0.0.0.0')
