require 'spec_helper'

def test_categorized_links(footer, cat_no, page_titles)
	wait = Selenium::WebDriver::Wait.new(timeout: 5)
	forsee = ForseePage.new()
	forsee.add_cookies()

	for i in 0 .. page_titles.length-1
		#Click link
		wait.until { footer.categorized_link(cat_no,i+1).displayed? }
		js_scroll_up(footer.categorized_link(cat_no,i+1),true)
		footer.categorized_link(cat_no,i+1).click
		#Make sure we're on the right page
		begin
			wait.until { $test_driver.title.include? page_titles[i] }
		#Give more information on error
		rescue Selenium::WebDriver::Error::TimeOutError
			$logger.info("Error loading page " + page_titles[i])
			fail("Error loading page " + page_titles[i])
		end
	end
end

describe "Footer functionality" do
	footer = FooterPage.new()
	forsee = ForseePage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can use all links in the footer correctly" do
		$logger.info("User can use all links in the footer correctly")

		#Load page titles from json
		parsed = JSON.parse(open("spec/page_titles.json").read)

		it " - Social media links" do
			forsee.add_cookies()
			$logger.info("Social media links")

			$logger.info("Blog link")
			footer.blog_link.click
			wait.until { $test_driver.title.include? "Blog" }

			$logger.info("Patient forms link")
			footer.patient_forms_link.click
			wait.until { $test_driver.title.include? "Patient Forms" }

			#These links open in a new tab, so we need to handle that
			$logger.info("Youtube link")
			footer.youtube_link.click
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "youtube.com/user/smilestories" }
			if ENV['BROWSER_TYPE'] == 'IE' #IE needs to be tricked into not prompting the user to close the window
				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
			else
				$test_driver.execute_script("window.close();")
			end
			$test_driver.switch_to.window( $test_driver.window_handles.first )

			$logger.info("Facebook link")
			footer.facebook_link.click
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "facebook.com/AspenDental" }
			if ENV['BROWSER_TYPE'] == 'IE'
				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
			else
				$test_driver.execute_script("window.close();")
			end
			$test_driver.switch_to.window( $test_driver.window_handles.first )

			$logger.info("Twitter link")
			footer.twitter_link.click
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "twitter.com/aspendental" }
			if ENV['BROWSER_TYPE'] == 'IE'
				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
			else
				$test_driver.execute_script("window.close();")
			end
			$test_driver.switch_to.window( $test_driver.window_handles.first )
		end

		it " - Dental services links" do
			forsee.add_cookies()
			$logger.info("Dental services links")

			#Heading
			footer.dental_services_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["dental-services"] }
			#Modify json data to match footer
			parsed["dental-services"].delete("root-canal-cost")
			parsed["dental-services"].delete("dental-implant-cost")
			parsed["dental-services"].delete("teeth-whitening")
			parsed["dental-services"].delete("dental-veneers")
			test_categorized_links(footer,1,parsed["dental-services"].values)
		end

		it " - Dentures links" do
			forsee.add_cookies()
			$logger.info("Dentures links")

			footer.dentures_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["dentures"] }
			parsed["dentures"].delete("denture-cost")
			parsed["dentures"].delete("denture-warranties")
			parsed["dentures"].delete("cast-partial")
			parsed["dentures"].delete("flexilytes")
			parsed["dentures"].delete("flexilytes-combo")
			parsed["dentures"].delete("basic-full")
			parsed["dentures"].delete("classic-full")
			parsed["dentures"].delete("naturalytes")
			parsed["dentures"].delete("comfilytes")
			parsed["dentures"].delete("when-to-get-dentures")
			parsed["dentures"].delete("denture-facts-mythos")
			parsed["dentures"].delete("how-to-clean-dentures")
			# https://cpbgroup.atlassian.net/browse/AD-1061
			parsed["dentures"].delete("securedent")
			test_categorized_links(footer,2,parsed["dentures"].values)
		end

		it " - Pricing and offers link" do
			forsee.add_cookies()
			$logger.info("Pricing and offers link")

			footer.pricing_and_offers_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["pricing-offers"] }
		end

		it " - Patient reviews link" do
			forsee.add_cookies()
			$logger.info("Patient reviews link")

			footer.patient_reviews_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["reviews"] }
		end

		it " - What to expect links" do
			forsee.add_cookies()
			$logger.info("What to expect links")

			footer.what_to_expect_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["what-to-expect"] }
			test_categorized_links(footer,3,parsed["what-to-expect"].values)
		end

		it " - Patient forms (cat) link" do
			forsee.add_cookies()
			$logger.info("Patient forms (cat) link")

			footer.patient_forms_cat_link.click
			wait.until { $test_driver.title.include? parsed["misc"]["patient-forms"] }
		end

		it " - Oral health links" do
			forsee.add_cookies()
			$logger.info("Oral health links")

			footer.oral_health_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["oral-health"] }
			parsed["oral-health"].delete("brushing")
			parsed["oral-health"].delete("flossing")
			test_categorized_links(footer,4,parsed["oral-health"].values)
		end

		it " - About link" do
			forsee.add_cookies()
			$logger.info("About link")

			footer.about_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["about"] }
		end

		it " - FAQ link" do
			forsee.add_cookies()
			$logger.info("FAQ link")

			footer.faq_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["faqs"] }
		end

		it " - My account link" do
			forsee.add_cookies()
			$logger.info("My account link")

			footer.my_account_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["my-account"] }
		end

		it " - Contact us link" do
			forsee.add_cookies()
			$logger.info("Contact us link")

			footer.contact_us_link.click
			wait.until { $test_driver.title.include? parsed["about"]["contact"] }
		end

		it " - Visit our job site link" do
			forsee.add_cookies()
			$logger.info("'Visit our job site' link")

			footer.job_site_link.click
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "www.aspendentaljobs.com" }
		end

		it " - Sign up CTA" do
			forsee.add_cookies()
			$logger.info("Sign up CTA")

			footer.sign_up_cta.click
			wait.until { $test_driver.title.include? parsed["misc"]["sign-up"] }
		end

		it " - Privacy policy link" do
			forsee.add_cookies()
			$logger.info("Privacy policy link")

			footer.privacy_policy_link.click
			wait.until { $test_driver.title.include? parsed["misc"]["privacy-policy"] }
		end

		it " - Terms of Use link" do
			forsee.add_cookies()
			$logger.info("Terms of Use link")

			footer.terms_of_use_link.click
			wait.until { $test_driver.title.include? parsed["misc"]["terms-of-use"] }
		end

		it " - Site Map link" do
			forsee.add_cookies()
			$logger.info("Site Map link")

			footer.site_map_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["site-map"] }
		end

		it " - Office listings link and copyright" do
			forsee.add_cookies()
			$logger.info("Office listings link and copyright")

			wait.until { footer.copyright.displayed? }
			footer.office_listings_link.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["office-listings"] }
		end
	end
end