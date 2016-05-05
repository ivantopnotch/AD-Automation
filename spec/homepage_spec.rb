require 'spec_helper'

describe "Homepage functionality" do
	homepage = HomepagePage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 5)
	forsee = ForseePage.new()

	describe " - User can use the homepage correctly" do
		$logger.info("User can use the homepage correctly")

		it " - Homepage links" do
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["top-pages"]["home"]

			#Test all links on homepage
			wait.until { homepage.hero_link.displayed? }
			test_link_back(homepage.hero_link, title, parsed["top-pages"]["SAA"])

			wait.until { homepage.dynamic_offic_link.displayed? }
			test_link_back(homepage.dynamic_offic_link, title, parsed["office"]["about-office"])

			wait.until { homepage.office_details_link.displayed? }
			test_link_back(homepage.office_details_link, title, parsed["office"]["about-office"])

			wait.until { homepage.schedule_cta.displayed? }
			test_link_back(homepage.schedule_cta, title, parsed["top-pages"]["SAA"])

			wait.until { homepage.find_another_office_link.displayed? }
			test_link_back(homepage.find_another_office_link, title, parsed["top-pages"]["FAO"])
			
			#Offers (opens modal)
			wait.until { homepage.offer_ctas.displayed? }
			begin
				homepage.offer_ctas.click
				wait.until { homepage.offer_modal.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				homepage.offer_ctas.click
				wait.until { homepage.offer_modal.displayed? }
			end
			sleep 1
			homepage.close_modal_cta.click
			wait_for_disappear(homepage.offer_modal, 5)

			# sleep 1
			# homepage.offer_ctas[1].click
			# wait.until { homepage.offer_modal.displayed? }
			# homepage.close_modal_cta.click
			# sleep 1

			wait.until { homepage.more_reviews_cta.displayed? }
			test_link_back(homepage.more_reviews_cta, title, parsed["reviews"]["read-reviews"])

			wait.until { homepage.like_on_facebook_link.displayed? }
			test_link_tab(homepage.like_on_facebook_link, nil, "www.facebook.com/AspenDental")

			wait.until { homepage.contact_us_link.displayed? }
			test_link_back(homepage.contact_us_link, title, parsed["about"]["contact"])

			wait.until { homepage.download_forms_cta.displayed? }
			test_link_back(homepage.download_forms_cta, title, parsed["misc"]["patient-forms"])
		end
	end
end