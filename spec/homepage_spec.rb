require 'spec_helper'

describe "Homepage functionality" do
	homepage = HomepagePage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 5)
	forsee = ForseePage.new()

	describe " - User can use the homepage correctly" do
		$logger.info("User can use the homepage correctly")

		parsed = JSON.parse(open("spec/page_titles.json").read)
		title = parsed["top-pages"]["home"]

		it " - Homepage hero" do
			$logger.info("Homepage hero")
			forsee.add_cookies()
			
			wait.until { homepage.hero_schedule_cta.displayed? }
			test_link_back(homepage.hero_schedule_cta, title, parsed["top-pages"]["SAA"])

			wait.until { homepage.hero_terms_conditions_link.displayed? }
			test_link_back(homepage.hero_terms_conditions_link, title, parsed["office"]["pricing-offers"])
		end

		it " - Homepage closest office tile" do
			$logger.info("Homepage closest office tile")
			forsee.add_cookies()
			geolocated_office = "Rapid City, SD" #Which office should appear by default

			#User Verifies existence of Closest office lockup
			wait.until { homepage.closest_office_details.displayed? }

			wait.until { homepage.dynamic_office_link.displayed? }
			#User verifies correct store is listed
			expect(homepage.dynamic_office_link.attribute("innerHTML").include? geolocated_office).to eql true
			test_link_back(homepage.dynamic_office_link, title, parsed["office"]["about-office"])

			#User verifies Owner Operator information displaying correctly
			wait.until { homepage.office_owner.displayed? }
			expect(homepage.office_details.displayed?).to eql true
			expect(homepage.office_details.attribute("innerHTML").include? geolocated_office).to eql true
			#Test links
			wait.until { homepage.office_details_link.displayed? }
			test_link_back(homepage.office_details_link, title, parsed["office"]["about-office"])

			wait.until { homepage.schedule_cta.displayed? }
			test_link_back(homepage.schedule_cta, title, parsed["top-pages"]["SAA"])

			wait.until { homepage.find_another_office_link.displayed? }
			test_link_back(homepage.find_another_office_link, title, parsed["top-pages"]["FAO"])
			
			#Offers (opens modal)
			offers = [homepage.first_offer_cta, homepage.second_offer_cta]
			offers.each do |offer|
				wait.until { offer.displayed? }
				num_retry = 0
				begin
					js_scroll_up(offer,true)
					offer.click
					wait.until { homepage.offer_modal.displayed? }
				rescue Selenium::WebDriver::Error::TimeOutError
					retry if (num_retry += 1) == 1
				end
				sleep 1
				expect(homepage.print_cta.displayed?).to eql true
				homepage.close_modal_cta.click
				wait_for_disappear(homepage.offer_modal, 5)
			end
		end

		it " - Homepage interacted office" do
			$logger.info("Homepage interacted office")
			forsee.add_cookies()

			#Manually navigate to an office
			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/prescott-valley-az-86314-2278")
			sleep 1
			#Navigate back to home
			HeaderPage.new().logo.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["home"] }

			#Verify interacted office is listed
			wait.until { homepage.office_details.displayed? }
			expect(homepage.office_details.attribute("innerHTML").include? "Prescott Valley, AZ").to eql true
		end

		it " - Homepage testimonials tile" do
			$logger.info("Homepage testimonials tile")
			forsee.add_cookies()

			wait.until { homepage.testimonials_tile.displayed? }

			wait.until { homepage.more_reviews_cta.displayed? }
			test_link_back(homepage.more_reviews_cta, title, parsed["reviews"]["read-reviews"])

			wait.until { homepage.like_on_facebook_link.displayed? }
			test_link_tab(homepage.like_on_facebook_link, nil, "www.facebook.com/AspenDental")
		end

		 it " - Homepage emergency and patien forms tiles" do
		 	$logger.info("Homepage emergency and patien forms tiles")
		 	forsee.add_cookies()

		 	wait.until{ homepage.emergency_tile.displayed? }
		 	wait.until{ homepage.emergency_number.displayed? }

			wait.until { homepage.contact_us_link.displayed? }
			test_link_back(homepage.contact_us_link, title, parsed["about"]["contact"])

			#Patient forms
			wait.until { homepage.forms_tile.displayed? }

			#Click CTA and navigate to patient forms page
			wait.until { homepage.download_forms_cta.displayed? }
			homepage.download_forms_cta.click
			wait.until { $test_driver.title.include? parsed["misc"]["patient-forms"] }

			#Verify download links are valid
			homepage.download_pdf_ctas.each do |cta|
				#Split URL
				url = cta.attribute("href").split(".com/")
				response = nil
				Net::HTTP.start(url[0].split("https://").last + ".com", 80) {|http|
					response = http.head("/" + url[1])
				}
				if(response.code != "200")
					fail("Statement link returned code: " + response.code)
				end
			end
		end


	end
end