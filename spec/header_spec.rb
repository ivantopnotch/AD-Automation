require 'spec_helper'
require 'test_validation'

#Hover over element until dropdown appears
def hover_dropdown(hover_element, expected_element, timeout, error_msg)
	start_time = time_now_sec
	while !expected_element.displayed? do
    	if time_now_sec >= start_time + timeout
        	fail(error_msg)
    	end
    	#Try again
    	$test_driver.action.move_to(hover_element).perform
	end
end

def test_dropdown(header, drop_no, page_titles)
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	forsee = ForseePage.new()
	forsee.add_cookies()

	for i in 0 .. page_titles.length-1
		#Hover over dropdown
		wait.until { header.dropdown(drop_no).displayed? }
		puts page_titles[i]
		hover_dropdown(header.dropdown(drop_no),header.dropdown_link(drop_no,i+1),3,"Header dropdown #"+drop_no.to_s+", link #"+i.to_s+" did not appear")

		#Click link and check page title
		begin
			header.dropdown_link(drop_no,i+1).click
			wait.until { $test_driver.title.include? page_titles[i] }
		rescue Selenium::WebDriver::Error::TimeOutError
			fail("Error loading page " + page_titles[i])
		end
	end
end

describe "Header functionality" do
	header = HeaderPage.new()
	scroll_sleep_time = 3
	forsee = ForseePage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can use all links in the header correctly" do
		$logger.info("User can use all links in the header correctly")

		#Load page titles from json
		parsed = JSON.parse(open("spec/page_titles.json").read)

		it " - Logo link" do
			$logger.info("Logo link")
			header.logo.click
    		wait.until { $test_driver.title.include? parsed["top-pages"]["home"] }
    	end

		it " - SAA CTA" do
			$logger.info("SAA CTA")
			header.saa_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["SAA"] }
		end

		it " - FAO CTA" do
			$logger.info("FAO CTA")
			header.fao_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["FAO"] }
		end

		it " - 'Search this site' CTA" do
			$logger.info("'Search this site' CTA")
			header.search_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["search"] }
		end

		it " - 'My account' CTA" do
			$logger.info("'My account' CTA")
			header.my_account_cta.click
			wait.until { $test_driver.title.include? parsed["my-account"]["sign-in"] }
		end

		it " - Dental Services dropdown" do
			$logger.info("Dental Services dropdown")
			#Test link
			wait.until { header.dropdown(1).displayed? }
			header.dropdown(1).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["dental-services"] }
			#Modify page titles to match header
			parsed["dental-services"].delete("root-canal-cost")
			parsed["dental-services"].delete("dental-implant-cost")
			parsed["dental-services"].delete("teeth-whitening")
			parsed["dental-services"].delete("dental-veneers")
			test_dropdown(header,1,parsed["dental-services"].values)
		end

		it " - Dentures dropdown" do
			$logger.info("Dental Services dropdown")
			header.dropdown(2).click
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
			parsed["dentures"].delete("denture-facts-myths")
			test_dropdown(header,2,parsed["dentures"].values)
		end

		it " - Pricing & offers link" do
			$logger.info("Pricing & offers link")
			#Navigate to an office first so we don't end up at the generic page
			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/prescott-valley-az-86314-2278")
			sleep 1
			header.dropdown(3).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["pricing-offers"] }
		end

		it " - Patient reviews dropdown" do
			$logger.info("Patient reviews dropdown")
			header.dropdown(4).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["reviews"] }
			test_dropdown(header,4,parsed["reviews"].values)
		end

		it " - What to expect dropdown" do
			$logger.info("What to expect dropdown")
			header.dropdown(5).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["what-to-expect"] }
			test_dropdown(header,5,parsed["what-to-expect"].values)
		end

		it " - Oral health dropdown" do
			$logger.info("Oral health dropdown")
			header.dropdown(6).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["oral-health"] }
			parsed["oral-health"].delete("brushing")
			parsed["oral-health"].delete("flossing")
			test_dropdown(header,6,parsed["oral-health"].values)
		end

		it " - About dropdown" do
			$logger.info("About dropdown")
			header.dropdown(7).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["about"] }
			test_dropdown(header,7,parsed["about"].values)
		end

		it " - FAQs dropdown" do
			$logger.info("FAQs dropdown")
			header.dropdown(8).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["faqs"] }
			test_dropdown(header,8,parsed["faqs"].values)
		end

		it " - 'Search this site' page" do
			$logger.info("'Search this site' page")
			header.search_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["search"] }

			#XSS/Data Sanitization check
			header.search_field.send_keys("<IMG SRC=\"javascript:alert('XSS');\">")
			header.search_form.submit
			wait.until { header.search_keyword.displayed? }
			expect(header.search_keyword.attribute("innerHTML").include? "&lt;IMG SRC=\"javascript:alert('XSS');\"&gt;").to eql true

			#SQL injection sanitization check
			header.search_field.send_keys("SELECT * FROM members WHERE username = 'admin' AND password = 'password'")
			header.search_form.submit
			wait.until { header.search_keyword.displayed? }
			expect(header.search_keyword.attribute("innerHTML").include? "SELECT * FROM members WHERE username = 'admin' AND password = 'password'").to eql true

			#Search results
			header.search_field.send_keys("teeth")
			header.search_form.submit
			begin
				wait.until { header.search_results[0].displayed? }
			rescue NoMethodError
				fail("Search for 'teeth' returned no results")
			end
			expect(header.search_results.length > 0).to eql true
		end

		it " - My Account dropdown - Logged out" do
			drop_error = "My account dropdown did not appear"
			hover_dropdown(header.my_account_cta, header.sign_in_cta, 3, drop_error)
			test_link_back(header.sign_in_cta, parsed["top-pages"]["home"], parsed["my-account"]["sign-in"])
			hover_dropdown(header.my_account_cta, header.sign_in_cta, 3, drop_error)
			test_link_back(header.sign_up_link, parsed["top-pages"]["home"], parsed["my-account"]["sign-up"])
		end

		it " - My Account dropdown - Logged in" do
			forsee.add_cookies()
			myaccount = MyAccountPage.new()
			myaccount.perform_login("GuarantorW50","Aspen123!")

			drop_error = "My account dropdown did not appear"
			hover_dropdown(header.my_account_cta, header.view_account_cta, 3, drop_error)
			test_link_back(header.view_account_cta, parsed["my-account"]["my-account"], parsed["my-account"]["my-account"])
			hover_dropdown(header.my_account_cta, header.view_account_cta, 3, drop_error)
			#Will log us out; we should end up at the sign up page
			test_link_back(header.log_out_link, parsed["my-account"]["sign-up"], parsed["top-pages"]["home"])
		end

	end
end