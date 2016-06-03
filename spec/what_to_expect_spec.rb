require 'spec_helper'
require 'two_column_spec'

describe "What to Expect pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	tcp = TwoColumnPage.new()
	wte = WhatToExpectPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	parsed = JSON.parse(open("spec/page_titles.json").read)

	describe " - User can read What to Expect pages correctly" do
		$logger.info("User can read What to Expect pages correctly")

		it " - Sidebar" do
			$logger.info("Sidebar")
			#Click oral health link on header
			header.dropdown(5).click

			tc.test_sidebar_links(parsed["top-pages"]["what-to-expect"],parsed["what-to-expect"].values)
		end

		it " - What to Expect landing page" do
			$logger.info("What to Expect landing page")
			forsee.add_cookies()
			title = parsed["top-pages"]["what-to-expect"]
			header.dropdown(5).click
			wait.until { $test_driver.title.include? title }

			tc.billboard()

			tc.test_breadcrumbs("what-to-expect", nil, "What to Expect")

			test_link_back(wte.call_us_link, title, parsed["about"]["contact"])

			tc.test_closest_office_details(title)
		end

		it " - Peace of Mind Promise page" do
			$logger.info("Peace of Mind Promise page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["peace-of-mind-promise"]

			tc.navigate_header(5,1,title)
			wait.until { $test_driver.title.include? title }
			tc.billboard()
			tc.test_breadcrumbs("what-to-expect", "peace-of-mind-promise" , "What to Expect", "Peace Of Mind Promise")

			test_link_back(wte.local_practice_link, title, parsed["office"]["insurance-financing"])

			tc.test_closest_office_details(title)
		end

		it " - First Dental Visit page" do
			$logger.info("First Dental Visit page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["first-dental-visit"]

			tc.navigate_header(5,2,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "first-dental-visit-new-patient-exam-and-x-ray", "What to Expect", "First Dental Visit New Patient Exam And X Ray")

			#Test links
			test_link_back(wte.call_links[0],title,parsed["top-pages"]["FAO"])
			test_link_back(wte.write_link,title,parsed["about"]["contact"])
			test_link_back(wte.new_paperwork_link,title,parsed["misc"]["patient-forms"])
			#Uncomment this if they ever fix this link
			#test_link_back(wte.dental_plan_link,title,parsed["what-to-expect"]["understanding-dental-treatment"])
			test_link_back(wte.oral_health_link,title,parsed["top-pages"]["oral-health"])
			test_link_back(wte.call_links[1],title,parsed["about"]["contact"])
			test_link_back(wte.pomp_link,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(wte.schedule_link,title,parsed["top-pages"]["SAA"])

			tc.test_closest_office_details(title)
		end

		it " - Tips For Overcoming Dental Anxiety page" do
			$logger.info("Tips For Overcoming Dental Anxiety")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["overcoming-dental-anxiety"]

			tc.navigate_header(5,3,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "tips-for-overcoming-dental-anxiety", "What to Expect", "Tips For Overcoming Dental Anxiety")

			tc.test_closest_office_details(title)
		end

		it " - Emergency Dental Services page" do
			$logger.info("Emergency Dental Services page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["emergency-treatment"]

			tc.navigate_header(5,4,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "emergency-walk-in-dental-treatment", "What to Expect", "Emergency Walk In Dental Treatment")

			test_link_back(wte.search_link, title, parsed["top-pages"]["FAO"])

			tc.test_closest_office_details(title)
		end

		it " - Ongoing Care Appointment page" do
			$logger.info("Ongoing Care Appointment page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["on-going-care-appointment"]

			tc.navigate_header(5,5,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "ongoing-care-appointment", "What to Expect", "Ongoing Care Appointment")

			test_link_back(wte.oral_health_link, title, parsed["oral-health"]["oral-health-overall-health"])
			test_link_back(wte.periodontal_disease_link, title, parsed["oral-health"]["oral-health-overall-health"])

			tc.test_closest_office_details(title)
		end

		it " - Understanding Dental Treatment Plan page" do
			$logger.info("Understanding Dental Treatment Plan page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["understanding-dental-treatment"]

			tc.navigate_header(5,6,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "understanding-your-dental-treatment-plan", "What to Expect", "Understanding Your Dental Treatment Plan")

			test_link_back(wte.dental_services_link, title, parsed["top-pages"]["dental-services"])
			test_link_back(wte.pom_link, title, parsed["what-to-expect"]["peace-of-mind-promise"])

			tc.test_closest_office_details(title)
		end

		it " - Getting Dentures page" do
			$logger.info("Getting Dentures page")
			forsee.add_cookies()
			title = parsed["what-to-expect"]["getting-dentures"]

			tc.navigate_header(5,7,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("what-to-expect", "getting-dentures-what-to-expect", "What to Expect", "Getting Dentures What To Expect")

			test_link_back(wte.your_ad_practice_link, title, parsed["top-pages"]["FAO"])
			test_link_back(wte.reline_link, title, parsed["dentures"]["denture-repair-reline"])
			if ENV['BROWSER_TYPE'] != 'FIREFOX'
				test_link_back(wte.call_ahead_link, title, parsed["top-pages"]["FAO"])
			end
			test_link_back(wte.rebased_link, title, parsed["dentures"]["denture-repair-reline"])
			test_link_back(wte.overall_health_link, title, parsed["oral-health"]["oral-health-overall-health"])
			test_link_back(wte.view_details_cta, title, parsed["office"]["pricing-offers"])

			tc.test_closest_office_details(title)
		end
	end
end