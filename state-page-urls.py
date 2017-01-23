from lxml import html
from progress.bar import Bar
import requests
import sys

environment = 'https://www.aspendental.com'

print('\nTest environment: ' + environment)
response = input('Is this the correct environment? Y/N ')
if (response == 'n') | (response == 'N'):
	sys.exit()

states = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']
print('Searching ' + len(states) + ' states')

subpages = ['pricing-and-offers', 'dentures-and-partials', 'insurance-and-financing', 'reviews']
checksubpages = 0

response = input('Include office sub-pages (pricing-and-offers, dentures-and-partials, etc)? Y/N ')
if (response == 'y') | (response == 'Y'):
	checksubpages = 1

failures = []

print('Executing the test. Press Ctl+C to stop')
bar = Bar('Processing', max = 603, fill = '#')
for s in states:
	try:
		page = requests.get(environment + '/dentist/' + s)
		# Add the class here before running
		urls = html.fromstring(page.content).xpath('//div[@class=""]//a/@href')

		for u in urls:
			try:
				if (requests.get(environment + u).status_code != 200):
					failures.append(u)

				if (checksubpages):
					for sp in subpages:
						if (requests.get(environment + u + '/' + sp).status_code != 200):
							failures.append(u + '/' + sp)
			except:
				print('Error loading ' + u)
				failures.append(u)
				pass
			bar.next()
	except:
		print('Error loading the ' + s + ' state page')
		failures.append('/dentist/' + s)
		pass
bar.finish()

if (len(failures) > 0):
	print('These locations failed: \n', failures)
else:
	print('All locations passed!')