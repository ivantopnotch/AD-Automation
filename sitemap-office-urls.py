from lxml import html
from progress.bar import Bar
import requests
import sys

environment = 'https://delta-www.aspendental.com'

print('\nTest environment: ' + environment)
response = input('Is this the correct environment? Y/N ')
if (response == 'n') | (response == 'N'):
	sys.exit()

try:
	page = requests.get(environment + '/sitemap/offices')
except:
	print('Error loading offices page')
	sys.exit()

tree = html.fromstring(page.content)

urls = tree.xpath('//div[@class="content-box"]//a/@href')
failures = []

print('Executing the test. Press Ctl+C to stop')
bar = Bar('Processing', max = len(urls), fill = '#')
for u in urls:
	if (requests.get(environment + u).status_code != 200):
		failures.append(u)
	bar.next()
bar.finish()

if (len(failures) > 0):
	print('These locations failed: \n', failures)
else:
	print('All locations passed!')