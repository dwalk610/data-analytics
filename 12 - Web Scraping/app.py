# -*- coding: utf-8 -*-
from flask import Flask, render_template
import pymongo
import scrape_mars

# create instance of Flask app
app = Flask(__name__)

# create mongo connection
app.config["MONGO_URI"] = "mongodb://localhost:27017/mars_app"
mongo = PyMongo(app)

client = pymongo.MongoClient()
mongo = PyMongo(app, uri="mongodb://localhost:27017/mars_app")
db = client.mars_db
collection = db.mars_input

@app.route("/")
def home():
    mars_data = list(db.collection.find())[0]
    return render_template('index.html', mars_data=mars_data)

@app.route("/scrape")
def mars_scrape():
    mars_data = scrape_mars.scrape()
    db.collection.insert_one(mars_data)
    return render_template('scrape.html')

if __name__ == "__main__":
    app.run(debug=True)