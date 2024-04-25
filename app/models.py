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

# # Example model
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     username = db.Column(db.String(80), unique=True, nullable=False)
#     email = db.Column(db.String(120), unique=True, nullable=False)

#     def __repr__(self):
#         return f'<User {self.username}>'

