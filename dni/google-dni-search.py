import requests
import json
import time
import re
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

driver = webdriver.Chrome()
#driver.set_window_size(1600, 800)
queries = open('search-queries.txt', 'r').read().split('\n')
urlpattern = re.compile('^https:\/\/www\.aspendental\.com\/dentist\/[a-z]+\/[a-z]+\/[a-z0-9-]+$')
phonepattern = re.compile('[\W_]+')
failures = []

for query in queries:
    # Execute the initial search
    driver.get('http://www.google.com')
    assert 'Google' in driver.title
    searchField = driver.find_element_by_name('q')
    searchField.send_keys(query)
    searchField.send_keys(Keys.RETURN)

    try:
        # Wait for page to load (result class 'r' does not exist until then)
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, 'r')))
        resultElements = driver.find_elements_by_css_selector('.r a')
        officeUrls = []

        for element in resultElements:
            elementUrl = element.get_attribute('href')
            urlPatternResult = re.search(urlpattern, elementUrl)
            if urlPatternResult:
                officeUrls.append(elementUrl)

        if (len(officeUrls) > 0):
            for url in range(len(officeUrls)):
                driver.find_element_by_xpath('//a[@href="' + officeUrls[url] + '"]').click()
                WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, 'telephone')))
                
                # Get phone number from page
                time.sleep(1.5) # Wait for any javascript to execute
                phoneNumber = driver.find_element_by_class_name('telephone').text
                phoneNumber = phonepattern.sub('', phoneNumber)

                # Get facility number
                facilityNumber = driver.find_element_by_css_selector('.grid-third div').get_attribute('data-facility-number')
                json = requests.get('https://api.aspendental.com/v1/services/offices/' + facilityNumber).json()
                apiPhoneNumber = json['phone']

                if (apiPhoneNumber != phoneNumber):
                    failures.append('Number mismatch found for: ' + query)

                driver.execute_script('window.history.go(-1)')
                WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, 'r')))
        else:
            failures.append('No office details page found for: ' + query)
    except TimeoutException:
        print('Loading took too much time')

if (len(failures) > 0):
    print('These queries failed [', len(failures), ']: \n', failures)
else:
    print('All search queries passed!')

driver.quit()