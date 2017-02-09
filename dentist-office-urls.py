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
	page = requests.get(environment + '/dentist')
except:
	print('Error loading dentist offices page')
	sys.exit()

urls = html.fromstring(page.content).xpath('//div[@class="grid-quarter"]//a/@href')
failures = []

print('Executing the test. Press Ctl+C to stop')
bar = Bar('Processing', max = len(urls), fill = '#')
for u in urls:
	usource = requests.get(environment + u)

	if (usource.status_code != 200):
		failures.append(u + ' [' + str(usource.status_code) + ']')
	elif (usource.url != environment + u): # Ensure correct page was loaded
		failures.append(u + ' [301]')
	else:
		# Page loaded successfully, check all sub-pages
		rurls = html.fromstring(usource.content).xpath('//div[@class="grid-third"]//a/@href')

		for i in rurls:
			isource = requests.get(environment + i)

			if (isource.status_code != 200):
				failures.append(i + ' [' + str(isource.status_code) + ']')
			elif (isource.url != environment + i): # Ensure correct page was loaded
				failures.append(i + ' [301]')

	bar.next()
bar.finish()

if (len(failures) > 0):
	print('These locations failed [', len(failures), ']: \n', failures)
else:
	print('All locations passed!')