require 'spec_helper'
require 'two_column_spec'

def test_faq_items(faq)
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	#Test anchors
	$logger.info("Anchors")
	faq.items.each do |elem|
		#Click oral_health item
		js_scroll_up(elem,true)
		elem.click
		# Make sure we are anchored to the id
		wait.until { faq.anchor(elem.attribute("href")) }
	end

	#Test all 'Back to top' links
	$logger.info("'Back to top' links")
	faq.back_to_top_links.each do |link|
		#Make sure its anchor is correct
		expect(link.attribute("href").split("#").last).to eql "content"
		#Make sure we're anchored correctly upon click
		js_scroll_up(link,true)
		link.click
		wait.until { faq.heading.displayed? }
	end
end

describe "Faq pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	faq = FaqPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can read faq pages correctly" do
		$logger.info("User can read faq pages correctly")

		#Load page titles from json
		parsed = JSON.parse(open("spec/page_titles.json").read)

		# it " - Sidebar" do
		# 	$logger.info("Sidebar")
		# 	#Click oral health link on header
		# 	header.dropdown(8).click
		# 	#These are the expected page titles, NOT the link text
		# 	tc.test_sidebar_links(parsed["top-pages"]["faqs"],parsed["faqs"].values)
		# end

		it " - FAQ landing page" do
			$logger.info("FAQ landing page")
			forsee.add_cookies()
			title = parsed["top-pages"]["faqs"]

			header.dropdown(8).click
			#Billboard
			tc.billboard
			#Breadcrumbs
			tc.test_breadcrumbs("faqs",nil,"FAQs")
			#Test all links
			$logger.info("In-text links")
			test_link_back(faq.call_or_email_link, title, parsed["about"]["contact"])
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - My first visit page" do
			$logger.info("My first visit page")
			forsee.add_cookies()
			title = parsed["faqs"]["my-first-visit"]
			#Hover over dropdown and click link
			tc.navigate_header(8,1,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","my-first-visit","FAQs","My First Visit")
			#Test all links
			$logger.info("In-text links")
			test_link_back(faq.new_patient_forms_link, title, parsed["misc"]["patient-forms"])
			test_link_back(faq.download_patient_forms_cta, title, parsed["misc"]["patient-forms"])
			test_link_back(faq.treatment_plan_link, title, parsed["what-to-expect"]["understanding-dental-treatment"])

			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end

		it " - Dental Appointments page" do
			$logger.info("Dental Appointments page")
			forsee.add_cookies()
			title = parsed["faqs"]["appointments"]
			#Hover over dropdown and click link
			tc.navigate_header(8,2,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","appointments","FAQs","Appointments")
			#Test all links
			$logger.info("In-text links")
			test_link_back(faq.pricing_and_offers_link, title, parsed["office"]["pricing-offers"])
			test_link_back(faq.here_link, title, parsed["office"]["insurance-financing"])
			test_link_back(faq.please_click_here_link, title, parsed["what-to-expect"]["overcoming-dental-anxiety"])
			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end

		it " - Dental Services page" do
			$logger.info("Dental Services page")
			forsee.add_cookies()
			title = parsed["faqs"]["dental-services"]
			#Hover over dropdown and click link
			tc.navigate_header(8,3,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","dental-services-faq","FAQs","Dental Services")
			#Test all links
			test_link_back(faq.here_links[0], title, parsed["what-to-expect"]["first-dental-visit"])
			test_link_back(faq.here_links[1], title, parsed["top-pages"]["SAA"])
			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end

		it " - Dentures page" do
			$logger.info("Dentures page")
			forsee.add_cookies()
			title = parsed["faqs"]["dentures"]
			#Hover over dropdown and click link
			tc.navigate_header(8,4,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","dentures-faq","FAQs","Dentures")
			#Test all links
			test_link_back(faq.ad_dentures_link, title, parsed["dentures"]["types-of-dentures"])
			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end

		it " - My Account page" do
			$logger.info("My Account page")
			forsee.add_cookies()
			title = parsed["faqs"]["my-account"]
			#Hover over dropdown and click link
			tc.navigate_header(8,5,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","my-account-faq","FAQs","My Account")
			#Test all links
			test_link_back(faq.my_account_link, title, parsed["top-pages"]["my-account"])
			test_link_back(faq.login_link, title, parsed["top-pages"]["my-account"])
			test_link_back(faq.contact_us_link, title, parsed["about"]["contact"])
			test_link_back(faq.here_link, title, parsed["top-pages"]["my-account"])

			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end

		it " - Oral Hygiene page" do
			$logger.info("Oral Hygiene page")
			forsee.add_cookies()
			title = parsed["faqs"]["oral-hygiene"]
			#Hover over dropdown and click link
			tc.navigate_header(8,6,title)
			#Breadcrumbs
			tc.test_breadcrumbs("faqs","oral-hygiene-faq","FAQs","Oral Hygiene")
			#Test all links
			test_faq_items(faq)
			#Closest office container
			tc.test_closest_office_details(title,true)
		end
	end
end