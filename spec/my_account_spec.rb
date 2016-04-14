require 'spec_helper'

describe "My Account functionality" do
	myaccount = MyAccountPage.new()
	forsee = ForseePage.new()
	header = HeaderPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can use My Account section correctly" do
		$logger.info("User can use My Account section correctly")

		it " - Sign in page validation" do
			$logger.info("Sign in page validaton")

			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }
			#myaccount.username_field.send_keys(('a'..'z').to_a.shuffle[0,8].join)

			#Valid username, invalid password
			myaccount.username_field.send_keys("guarantorNDNA")
			myaccount.password_field.send_keys("Aspen123!")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			wait.until { myaccount.form_error_msg.displayed? }
		end
	end
end