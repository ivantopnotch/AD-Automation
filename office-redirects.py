from lxml import html
from progress.bar import Bar
import requests
import sys

environment = 'https://uat-web.aspendental.com'

# Comment this section out if executing run-all.sh
print('\nTest environment: ' + environment)
response = input('Is this the correct environment? Y/N ')
if (response == 'n') | (response == 'N'):
	sys.exit()
# ================================================

try:
	page = requests.get(environment)
except:
	print('Error loading environment')
	sys.exit()

oldurls = open('old-office-urls.txt', 'r').read().split(',')
failures = []

print('Executing the test. Press Ctl+C to stop')
bar = Bar('Processing', max = len(oldurls), fill = '#')
for u in oldurls:
	usource = requests.get(environment + u)

	# This div only exists on office detail pages
	officediv = html.fromstring(usource.content).xpath('//div[@class="office-header"]') 

	if (usource.status_code != 200):
		failures.append(u + ' [' + str(usource.status_code) + ']')
	elif (len(officediv) == 0): # Ensure office detail page was loaded
		failures.append(u + ' [301]')

	bar.next()
bar.finish()

if (len(failures) > 0):
	print('These locations failed [', len(failures), ']: \n', failures)
else:
	print('All locations passed!')