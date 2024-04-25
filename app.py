from flask import Flask
# from app.models import db
import openai
import logging
import sys
from app.utils import get_secret

from app.routes import main  # Make sure to adjust the import path according to your package structure

# def init_db():
#     db.create_all()

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)

def create_app():
    app = Flask(__name__)
    # Register the Blueprint
    app.register_blueprint(main)
    app.config['OPENAI_API_KEY'] = get_secret("openai_api_key", "us-east-1")
    openai.api_key = app.config['OPENAI_API_KEY']
    logging.info(f"openai_key: {openai.api_key}")

    # with app.app_context():
    #     init_db()

    return app


if __name__ == '__main__':
    # Set up the OpenAI API key

    app = create_app()
    app.run(debug=True, host='0.0.0.0')
