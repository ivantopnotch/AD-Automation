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
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }
			#myaccount.username_field.send_keys(('a'..'z').to_a.shuffle[0,8].join)

			#Valid username, invalid password
			myaccount.username_field.send_keys("guarantorNDNA")
			myaccount.password_field.send_keys("1")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			wait.until { myaccount.form_error_msg.displayed? }

			#Invalid username, valid password
			myaccount.username_field.clear
			myaccount.password_field.clear
			myaccount.username_field.send_keys("a")
			myaccount.password_field.send_keys("Valid987$")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			wait.until { myaccount.form_error_msg.displayed? }

			#Invalid username, invalid password
			myaccount.username_field.clear
			myaccount.password_field.clear
			myaccount.username_field.send_keys("a")
			myaccount.password_field.send_keys("a")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			wait.until { myaccount.form_error_msg.displayed? }

			#Valid username, valid password
			myaccount.username_field.clear
			myaccount.password_field.clear
			myaccount.username_field.send_keys("guarantorNDNA")
			myaccount.password_field.send_keys("Aspen123!")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			Selenium::WebDriver::Wait.new(timeout: 5, message: "My Account page failed to load in time after signing in").until { myaccount.sign_out_link.displayed? }
		end

		it " - Forgot username flow" do
			$logger.info("Forgot username flow")
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }

			#Open modal
			myaccount.forgot_username_link.click
			wait.until { myaccount.fu_container.displayed? }

			#Test required fields
			myaccount.fu_submit_cta.click
			wait.until { myaccount.fu_fname_field.attribute("class") == "text-field is-error"}
			wait.until { myaccount.fu_lname_field.attribute("class") == "text-field is-error"}
			wait.until { myaccount.fu_account_no_field.attribute("class") == "text-field is-error"}

			#Invalid account
			myaccount.fu_fname_field.send_keys("FName")
			myaccount.fu_lname_field.send_keys("LName")
			myaccount.fu_account_no_field.send_keys("12345")
			myaccount.fu_submit_cta.click
			wait.until { myaccount.fu_message.displayed? }
			error_msg = myaccount.fu_message.attribute("innerHTML")

			#Close/reopen modal
			myaccount.fu_close_cta.click
			wait_for_disappear(myaccount.fu_message,3)
			myaccount.forgot_username_link.click
			wait.until { myaccount.fu_container.displayed? }
			
			#Valid account
			myaccount.fu_fname_field.send_keys("richard")
			myaccount.fu_lname_field.send_keys("test")
			myaccount.fu_account_no_field.send_keys("1021")
			myaccount.fu_submit_cta.click
			wait.until { myaccount.fu_message.displayed? }
			#Make sure we didn't recieve error message again
			expect(myaccount.fu_message.attribute("innerHTML") != error_msg)
		end

		it " - Forgot password flow" do
			$logger.info("Forgot password flow")
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }

			#Open modal
			myaccount.forgot_password_link.click
			wait.until { myaccount.fp_container.displayed? }

			#Check required field
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_text_field.attribute("class") == "text-field name is-error" }

			#Invalid username
			myaccount.fp_text_field.send_keys("asdf")
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_text_field.attribute("class") == "text-field name is-error" }

			#Valid username
			myaccount.fp_text_field.clear
			myaccount.fp_text_field.send_keys("guarantorNDNA")
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

			#Invalid security answer
			myaccount.fp_text_field.send_keys("asdf")
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_message.displayed? }

			#Close/reopen modal
			myaccount.fp_close_cta.click
			wait_for_disappear(myaccount.fp_message,3)
			myaccount.forgot_password_link.click
			wait.until { myaccount.fp_container.displayed? }
			myaccount.fp_text_field.send_keys("guarantorNDNA")
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

			#Valid security answer
			myaccount.fp_text_field.clear
			myaccount.fp_text_field.send_keys("emerald")
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_password_field.displayed? }

			#Two password requirement
			myaccount.fp_password_field.send_keys("Aspen123!")
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_error_msg.displayed? }

			#Non-matching passwords
			myaccount.fp_password_field.click
			myaccount.fp_confirm_pass_field.send_keys("Aspen1231")
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_error_msg.displayed? }

			#Valid passwords
			myaccount.fp_confirm_pass_field.clear
			myaccount.fp_confirm_pass_field.send_keys("Aspen123!")
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_reset_message.displayed? }
		end

		it "My Account (signed in) page" do
			$logger.info("My Account (signed in) page")
			forsee.add_cookies()

			#Sign in
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }
			myaccount.username_field.send_keys("guarantorNDNA")
			myaccount.password_field.send_keys("Aspen123!")
			myaccount.login_form.submit
			Selenium::WebDriver::Wait.new(timeout: 7, message: "My Account page failed to load in time after signing in").until { myaccount.make_a_payment_link.displayed? }

			
		end
	end
end