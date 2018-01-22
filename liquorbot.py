
# -*- coding: utf-8 -*-
import requests
from bs4 import  BeautifulSoup
#from pyquery import PyQuery as pq

###open text
fo = open("licenseinformation.text", "w")
zipcodes=['10024','12084','10028']
### scrapy data in reqired zipcodes
for zipcode in zipcodes:
### submit form data to server
    data = {'pageName':'com.ibm.nysla.data.publicquery.PublicQueryPremisesSearchPage','validated':'true', 'address1':'', 'address2':'', 'city':'', 'county':'' ,'zipCode':zipcode}
    origincode = requests.post("https://www.tran.sla.ny.gov/servlet/ApplicationServlet", data=data).content
    soup=BeautifulSoup(origincode,"lxml")


###write data into text
    tags=soup.find_all('td',class_="displayvalue")
    for tag in tags:
	    text=tag.get_text()
	    fo.write(text)
###close
fo.close()