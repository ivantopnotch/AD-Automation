import requests
import json
import time
import sys
import re
from lxml import html
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

driver = webdriver.Chrome()
#driver.set_window_size(1600, 800)
utmsources = open('utm-sources.txt', 'r').read().split('\n')
phonepattern = re.compile('[\W_]+')
failures = []

environment = 'https://uat-web.aspendental.com'
apienvironment = 'https://uat-api.aspendental.com'

# Comment this section out if executing run-all.sh
print('\nTest environment: ' + environment)
print('API environment: ' + apienvironment)
response = input('Are these the correct environments? Y/N ')
if (response == 'n') | (response == 'N'):
	sys.exit()
# ================================================

try:
	officespage = requests.get(environment + '/sitemap/offices')
except:
	print('Error loading offices page')
	sys.exit()

officeurls = html.fromstring(officespage.content).xpath('//div[@class="content-box"]//a/@href')

# CHANGE THIS LATER TO ALL OFFICES
for url in officeurls[0:3]:
	driver.get(environment + url)
	facilityNumber = driver.find_element_by_css_selector('.grid-third div').get_attribute('data-facility-number')
	json = requests.get(apienvironment + '/v1/services/offices/' + facilityNumber).json()
	dnijson = json['dni']

	for source in utmsources:
		sourceurl = environment + url + '?utm_source=' + source
		driver.get(sourceurl)
		dninumber = dnijson[source]
		time.sleep(1.5) # Wait for any javascript to execute
		phonenumber = driver.find_element_by_class_name('telephone').text
		phonenumber = phonepattern.sub('', phonenumber) # Remove all non-alphanumeric characters

		if (phonenumber != dninumber):
			failures.append(sourceurl.replace(environment + '/dentist', ""))

if (len(failures) > 0):
    print('These DNI numbers failed: [', len(failures), ']: \n', failures)
else:
    print('All DNI numbers match the API!')

driver.quit()