require 'spec_helper'

describe "Epsilon sign-up page functionality" do
	header = HeaderPage.new()
	saa = SaaPage.new()
	epsilon = EpsilonPage.new()
	forsee = ForseePage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can sign up correctly" do
		$logger.info("User can sign up correctly")

		it " - Epsilon page" do
			$logger.info("Epsilon page")
			forsee.add_cookies()

			# Click SAA link
			$logger.info("SAA CTA")
			header.saa_cta.click
			wait.until { $test_driver.title.include? "Schedule a Dentist Appointment" }
			sleep scroll_sleep_time
			# Open abandonment modal and click "remind me later"
			$logger.info("Abandonment modal")
			wait.until { saa.logo_link.displayed? }
			saa.logo_link.click
			wait.until { saa.abandonment_modal.displayed? }
			wait.until { saa.remind_me_later.displayed? }
			saa.remind_me_later.click
			$logger.info("Sign up page")
			sleep scroll_sleep_time
			expect($test_driver.title.include? "Signup")

			#Setting cookies doesn't work for firefox
			# if ENV['BROWSER_TYPE'] == 'FIREFOX'
			# 	forsee.wait_close_modal()
			# end

			$logger.info("First name")
			#Check invalid input
			#Errors will include "is-error" in class name
			epsilon.first_name.send_keys("1235")
			#Click another element to fire on-blur
			epsilon.last_name.click
			#Check for error
			expect(epsilon.first_name.attribute("class").include? "is-error").to eql true
			#Check valid input
			epsilon.first_name.clear
			epsilon.first_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "'")
			epsilon.last_name.click
			expect(epsilon.first_name.attribute("class").include? "is-error").to eql false

			$logger.info("Last name")
			#Check invalid input
			epsilon.last_name.send_keys("1235")
			epsilon.first_name.click
			expect(epsilon.last_name.attribute("class").include? "is-error").to eql true
			#Check valid input
			epsilon.last_name.clear
			epsilon.last_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "-" + ('a'..'z').to_a.shuffle[0,8].join)
			epsilon.first_name.click
			expect(epsilon.last_name.attribute("class").include? "is-error").to eql false

			$logger.info("Eamil")
			valid_email = ('a'..'z').to_a.shuffle[0,8].join + "@topnotchltd.com" #Need this for both email fields
			#Check invalid input
			epsilon.email.send_keys("a@a")
			epsilon.first_name.click
			expect(epsilon.email.attribute("class").include? "is-error").to eql true
			#Check valid input
			epsilon.email.clear
			epsilon.email.send_keys(valid_email)
			epsilon.first_name.click
			expect(epsilon.email.attribute("class").include? "is-error").to eql false

			$logger.info("Confirm Eamil")
			#Check invalid input
			epsilon.confirm_email.send_keys("a@a")
			epsilon.first_name.click
			expect(epsilon.confirm_email.attribute("class").include? "is-error").to eql true
			#Check non-matching (but valid) email
			epsilon.confirm_email.clear
			epsilon.confirm_email.send_keys("different@email.com")
			epsilon.first_name.click
			expect(epsilon.confirm_email.attribute("class").include? "is-error").to eql true
			#Check valid input
			epsilon.confirm_email.clear
			epsilon.confirm_email.send_keys(valid_email)
			epsilon.first_name.click
			expect(epsilon.confirm_email.attribute("class").include? "is-error").to eql false

			$logger.info("Zip code")
			#Check invalid input
			epsilon.zip_code.send_keys("asdfj")
			epsilon.first_name.click
			expect(epsilon.zip_code.attribute("class").include? "is-error").to eql true
			#Too many digits
			epsilon.zip_code.clear
			epsilon.zip_code.send_keys("123456")
			epsilon.first_name.click
			expect(epsilon.zip_code.attribute("class").include? "is-error").to eql true
			#Check valid input
			epsilon.zip_code.clear
			epsilon.zip_code.send_keys(rand(10000 .. 90000))
			epsilon.first_name.click
			expect(epsilon.zip_code.attribute("class").include? "is-error").to eql false

			$logger.info("Select month")
			# Make sure we can't continue unless we select a month
			epsilon.submit_cta.click
			wait.until { epsilon.month_error.displayed? }
			# Click a month option
			epsilon.select_month.click
			wait.until { epsilon.month_option.displayed? }
			epsilon.month_option.click
			wait_for_disappear(epsilon.month_error, scroll_sleep_time)

			$logger.info("Honeypot")
			#Make sure honeypot is invisible
			wait_for_disappear(epsilon.gender, scroll_sleep_time)

			$logger.info("Submit sign up")
			epsilon.submit_cta.click
			Selenium::WebDriver::Wait.new(timeout: 20).until { epsilon.thank_you.displayed? }
		end
	end
end