from flask import Flask, request, render_template, redirect, url_for, session
import mysql.connector
import re

app = Flask(__name__)
app.secret_key = 'rahasia'

def get_database_connection():
    return mysql.connector.connect(
        host="mysql.railway.internal",
        user="root",
        password="wAEZjtMKvXbDvgaxxALFxlqQSaJyoSjW",
        database="railway"
    )

app.py





if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
