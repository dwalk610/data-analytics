#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 16 00:59:47 2019

@author: donaldwalker
"""


#!/usr/bin/env python
# coding: utf-8

# In[92]:


# Dependencies
from bs4 import BeautifulSoup as bs
from splinter import Browser as br
import requests
import re
import pandas as pd



def init_browser():
    executable_path = {"executable_path": '/usr/local/bin/chromedriver'}
    browser = br('chrome')


# In[62]:

def scrape():
    
    # Nasa news url
    url = 'https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest'
    
    # Retrieve page with requests module 
    nasa = requests.get(url)
    
    
    # In[63]:
    
    
    # BeautifulSoup object parsed with html.parser
    soup = bs(nasa.text, 'lxml')
    print(soup.prettify)
    
    
    # In[64]:
    
    
    # Nasa's news site uses the 'slide' class in a list 'li' for each of their articles
    # The 'content_title' class is used to store news article titles
    
    # Create variable for first news title and print to test
    news_title = soup.find('div', class_="content_title")
    print(news_title.text)
    
    # Create variable for text of first paragraph
    # news_teaser = soup.find('div', class_="article_teaser_body")
    news_text = soup.find('div', class_="rollover_description_inner")
    print(news_text.text)
    
    
    # In[65]:
    
    
    
    
    
    # In[81]:
    
    
    # create url for jpl nasa site
    url_n = 'https://www.jpl.nasa.gov'
    
    # 2nd half of url, specific to mars
    mars_url = '/spaceimages/?search=&category=Mars'
    url_mars = f'{url_n}{mars_url}'
    
    browser.visit(url_mars)
    
    
    # In[83]:
    
    
    # html object
    mars_html = browser.html
    mars_soup = bs(mars_html, 'html.parser')
    
    # find front page smaller image url class
    img_code = mars_soup.find('article', class_="carousel_item")
    img_url = img_code.attrs['style']
    img_link = img_url.split("'")[1]
    img_lg_link = f'{url_n}{img_link}'
    print(img_lg_link)
    
    
    # # Mars Weather
    
    # In[87]:
    
    
    # Visit the Mars Weather twitter account and scrape the latest Mars weather tweet 
    # from the page. Save the tweet text for the weather report as a variable called mars_weather.
    
    url_twit = 'https://twitter.com/marswxreport?lang=en'
    html = requests.get(url_twit)
    twit_soup = bs(html.text, 'lxml')
    mars_weat_t = soup.find_all(string=re.compile("Sol"), 
                                 class_ = "TweetTextSize TweetTextSize--normal js-tweet-text tweet-text")[0].text
    mars_weat_t
    
    
    # # Mars Facts
    
    # In[99]:
    
    
    # Visit the Mars Facts webpage here and use Pandas to scrape the table containing facts about the planet including Diameter, Mass, etc.
    # Use Pandas to convert the data to a HTML table string.
    facts_url = 'https://space-facts.com/mars/'
    
    mars_df = pd.read_html(facts_url)[0]
    
    mars_df
    
    mars_df = mars_df.rename(columns={0:'Mars Data'})
    
    mars_dict = mars_df.to_dict(mars_df)
    
    return mars_dict
    
    # In[ ]:
    
    
    
    
    
