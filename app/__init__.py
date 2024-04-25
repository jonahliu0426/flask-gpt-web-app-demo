# from flask import Flask
# from flask_sqlalchemy import SQLAlchemy
# import os

# app = Flask(__name__)

# # Database configuration
# DB_USERNAME = os.getenv('RDS_USERNAME')
# DB_PASSWORD = os.getenv('RDS_PASSWORD')
# DB_HOST = os.getenv('RDS_HOSTNAME')
# DB_PORT = os.getenv('RDS_PORT', 5432)  # default port for PostgreSQL
# DB_NAME = os.getenv('RDS_DB_NAME')

# app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# db = SQLAlchemy(app)