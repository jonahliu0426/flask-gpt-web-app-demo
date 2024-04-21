from flask import Flask, request, render_template
from dotenv import load_dotenv
import openai
import os

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Set up the OpenAI API key
openai.api_key = os.getenv("OPENAI_API_KEY")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/ask', methods=['POST'])
def ask():
    user_input = request.form['user_input']
    response = openai.ChatCompletion.create(
        model="tts-1",
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": user_input}
        ]
    )
    answer = response.choices[0].message['content']
    return render_template('index.html', user_input=user_input, answer=answer)

if __name__ == '__main__':
    app.run(debug=True)
