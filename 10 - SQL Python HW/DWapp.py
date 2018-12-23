#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 19 04:03:54 2018

@author: donaldwalker
"""
################################################
# STEP 1 - CLIMATE ANALYSIS
################################################
import numpy as np
import pandas as pd

import numpy as np
import pandas as pd

import datetime as dt

# # Reflect Tables into SQLAlchemy ORM

# Python SQL toolkit and Object Relational Mapper
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func , desc, inspect

engine = create_engine("sqlite:///Resources/hawaii.sqlite",
                       connect_args = {'check_same_thread':False}
                       )

# reflect an existing database into a new model
Base = automap_base()

# reflect the tables
Base.prepare(engine, reflect=True)

# We can view all of the classes that automap found
Base.classes.keys()

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

# Create the inspector and connect it to the engine
inspector = inspect(engine)

# Query to retrieve the last 12 months of precipitation data

# Get column names and data types
columns_meas = inspector.get_columns('Measurement')

# Print column names and types
for names in columns_meas:
    print (names['name'],names['type'])

# Query for date 1 year ago from today
q_date = dt.date.today() - dt.timedelta(days=365)

# Note to TA - last date of data in csv file is 8/23/17
# I'll use 8/23/16 - 8/23/17 for data range

# Query for date 1 year ago from lastest date available in data
last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()

# Convert last date from text to datetime
last_dt = dt.datetime.strptime(last_date[0],"%Y-%m-%d")

# Calculate date 1 year earlier than last_date
first_date = last_dt - dt.timedelta(days=365)

precp_data = session.query(Measurement.date,Measurement.prcp).\
                            filter(Measurement.date >= first_date).all()

# Convert selected precipitation data to DataFrame
precp_pd = pd.DataFrame(precp_data)
precp_pd = precp_pd.set_index('date')

# Plot date
precp_pd.plot()

# Summary stats
precp_pd.describe()
    
# Get station table column names
cols_stations = inspector.get_columns('Station')
cols_stations

# Query to calculate number of stations
station_count = session.query(Station.station).count()
station_count

# List stations and observation counts in descending order
stations_obs = session.query(Measurement.station,func.count(Measurement.tobs)).\
                            group_by(Measurement.station).order_by(desc(func.count(Measurement.tobs))).\
                            limit(10).all() 

# Station with highest number of observations
station_most = stations_obs[0]
station_most

# Using the station id from the previous query, calculate the lowest temperature recorded, 
# highest temperature recorded, and average temperature most active station?

station_data = session.query(func.min(Measurement.tobs),
                    func.max(Measurement.tobs),
                    func.avg(Measurement.tobs)).\
                        filter(Measurement.station == station_most[0]).\
                        all()

# Choose the station with the highest number of temperature observations.
# Query the last 12 months of temperature observation data for this station
# Plot the results as a histogram

station_year = session.query(Measurement.tobs).\
                filter(Measurement.date >= first_date).\
                filter(Measurement.station == station_most[0]).\
                all()

station_year_pd = pd.DataFrame(station_year)

station_year_pd.plot.hist(bins=12)

#start_dt = dt.datetime.strptime('2016-01-01',"%Y-%m-%d")
start_dt = '2016-01-01'

                                
temp_data_t = session.query(func.min(Measurement.tobs),
                                func.max(Measurement.tobs),
                                func.avg(Measurement.tobs)).\
                                filter(Measurement.date >= start_dt).\
                                all()
temp_data_t[0]                                

#####################################################################################
# FLASK API DESIGN
#####################################################################################

from flask import Flask, jsonify

app = Flask(__name__)

# Flask routes
@app.route("/")
def welcome():
    '''Weclomes user and lists availble routes'''
    return(f'Available routes are f*** listed below<br/>'
           f'/api/v1.0/precipitation<br/>'
           f'/api/v1.0/stations<br/>'
           f'/api/v1.0/tobs<br/>'
           f'/api/v1.0/<start><br/>'
           f'/api/v1.0/<start>/<end>'
            )
    
##############################
# API for dates and temps data
##############################
@app.route('/api/v1.0/precipitation')
def precip():
    '''returns dates and temp observations from last yeer'''
    # Query for all dates and temp data from selected year
    dates_tobs = session.query(Measurement.date,Measurement.tobs).\
                    filter(Measurement.date >= first_date).\
                    all()
    
    # Create a dictionary from query results
    dates_dict = dict(dates_tobs)
                    
    return jsonify(dates_dict)

##############################
# API for list of stations
##############################
@app.route('/api/v1.0/stations')
def station_names():
    '''returns list of stations'''
    # Query for list of stations
    station_list = session.query(Station.station).all()
    
    return jsonify (station_list)

##############################
# API for List of Temperature Observations (tobs) for the previous year
##############################
@app.route('/api/v1.0/tobs')
def tobs():
    '''returns list of temperature observations for previous year'''
    # Query for temp obs    
    tobs_list = session.query(Measurement.tobs).\
                filter(Measurement.date >= first_date).\
                all()
    
    return jsonify (tobs_list)

##############################
# API for temp data for given date range
##############################

'''
Return JSON list of the min avg and max temp for given start or start-end range
 - When given the start only, calculate TMIN, TAVG, and TMAX for all dates 
   greater than and equal to start date
 - When given the start and the end date, calculate the TMIN, TAVG, and TMAX 
   for dates betΩween the start and end date inclusive
'''
@app.route('/api/v1.0/<start>')
def temp_data(start):
    
    # Convert start date to datetime object
    start_dt = dt.datetime.strptime(start,"%Y-%m-%d")
    
    # Query for temp data after given start date
    temp_data_q = session.query(func.min(Measurement.tobs),
                                func.max(Measurement.tobs),
                                func.avg(Measurement.tobs)).\
                                filter(Measurement.date >= start).\
                                all()
                            
    return jsonify(temp_data_q)
    

if __name__ == "__main__":
    app.run(debug=True)
              



