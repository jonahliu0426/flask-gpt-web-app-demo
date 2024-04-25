from flask import Blueprint, render_template, request
import openai
import logging

# Create a Blueprint
main = Blueprint('main', __name__)

@main.route('/')
def index():
    return render_template('index.html')

@main.route('/ask', methods=['POST'])
def ask():
    logging.info(f"openai_key: {openai.api_key}")
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
