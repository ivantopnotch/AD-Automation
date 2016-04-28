require 'spec_helper'

def login(username, password)
	myaccount = MyAccountPage.new()
	header = HeaderPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	wait_long = Selenium::WebDriver::Wait.new(timeout: 7)

	header.my_account_cta.click
	wait.until { $test_driver.current_url.include? "/my-account/login" }
	
	begin
		myaccount.username_field.send_keys(username)
		myaccount.password_field.send_keys(password)
		myaccount.login_form.submit
		wait_long.until { myaccount.make_a_payment_link.displayed? }
	rescue Selenium::WebDriver::Error::TimeOutError
		#Try again
		myaccount.username_field.send_keys(username)
		myaccount.password_field.send_keys(password)
		myaccount.login_form.submit
		wait_long.until { myaccount.make_a_payment_link.displayed? }
	end
end

describe "My Account functionality" do
	myaccount = MyAccountPage.new()
	forsee = ForseePage.new()
	header = HeaderPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	account_password = "Aspen123!"

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
			myaccount.password_field.send_keys("adsfjkl")
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
			wait.until { myaccount.form_uname_msg.displayed? }

			#Invalid username, invalid password
			myaccount.username_field.clear
			myaccount.password_field.clear
			myaccount.username_field.send_keys("a")
			myaccount.password_field.send_keys("a")
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			wait.until { myaccount.form_uname_msg.displayed? }

			#Valid username, valid password
			myaccount.username_field.clear
			myaccount.password_field.clear
			myaccount.username_field.send_keys("guarantorNDNA")
			myaccount.password_field.send_keys(account_password)
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
			begin
				myaccount.forgot_username_link.click
				wait.until { myaccount.fu_container.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				myaccount.forgot_username_link.click
				wait.until { myaccount.fu_container.displayed? }
			end

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
			begin
				myaccount.forgot_password_link.click
				wait.until { myaccount.fp_container.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				myaccount.forgot_password_link.click
				wait.until { myaccount.fp_container.displayed? }
			end

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
			myaccount.fp_password_field.send_keys(account_password)
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_error_msg.displayed? }

			#Non-matching passwords
			myaccount.fp_password_field.click
			myaccount.fp_confirm_pass_field.send_keys("Aspen1231")
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_error_msg.displayed? }

			#Valid passwords
			myaccount.fp_confirm_pass_field.clear
			myaccount.fp_confirm_pass_field.send_keys(account_password)
			myaccount.fp_pass_submit_cta.click
			wait.until { myaccount.fp_reset_message.displayed? }
		end

		it " - My Account (Guarantor) page" do
			$logger.info("My Account (Guarantor) page")
			forsee.add_cookies()

			login("guarantorNDNA", account_password)

			#Verify elements
			expect(myaccount.welcome_text.displayed?).to eql true
			expect(myaccount.sign_out_link.displayed?).to eql true
			expect(myaccount.office_details.displayed?).to eql true
			expect(myaccount.empty_notification.displayed?).to eql true

			#Test links
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["my-account"]["my-account"]

			#Sidebar
			test_link_back(myaccount.my_account_sidebar_link, title, title)
			test_link_back(myaccount.my_account_statements_link, title, parsed["my-account"]["statements"])
			test_link_back(myaccount.manage_appointments_link, title, parsed["my-account"]["manage-appointments"])
			test_link_back(myaccount.update_password_link, title, parsed["my-account"]["update-password"])

			test_link_back(myaccount.account_info_statements, title, parsed["my-account"]["statements"])

			test_link_back(myaccount.tools_manage_appointments, title, parsed["my-account"]["manage-appointments"])

			test_link_back(myaccount.profile_update_password_link, title, parsed["my-account"]["update-password"])
		end

		it " - Update password page validation" do
			$logger.info("Update password validation")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			#Navigate to update password page
			myaccount.update_password_link.click
			wait.until { $test_driver.title.include? parsed["my-account"]["update-password"] }

			#Valid password, but new pass is less than 8 characters
			myaccount.pass_old.send_keys(account_password)
			myaccount.pass_new.send_keys("Aa123!")
			myaccount.pass_confirm.send_keys("Aa123!")
			myaccount.pass_submit_cta.click
			#Check error message
			expect(myaccount.pass_form_error.attribute("innerHTML").include? "at least 8 characters").to eql true

			#Valid password, but new pass doesn't contain capital letter
			myaccount.pass_new.clear
			myaccount.pass_new.send_keys("aspen123!")
			myaccount.pass_confirm.clear
			myaccount.pass_confirm.send_keys("aspen123!")
			myaccount.pass_submit_cta.click
			expect(myaccount.pass_form_error.attribute("innerHTML").include? "at least 1 uppercase letter").to eql true

			#Valid password, but new pass doesn't contain special character
			myaccount.pass_new.clear
			myaccount.pass_new.send_keys("Aspen1231")
			myaccount.pass_confirm.clear
			myaccount.pass_confirm.send_keys("Aspen1231")
			myaccount.pass_submit_cta.click
			expect(myaccount.pass_form_error.attribute("innerHTML").include? "at least 1 special character").to eql true
		end

		it " - Statements page" do
			$logger.info("Statements page")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("Stateme1", account_password)

			#Navigate to update password page
			myaccount.my_account_statements_link.click
			wait.until { $test_driver.title.include? parsed["my-account"]["statements"] }

			puts "Checking statement PDF links"
			myaccount.statements.each do |statement|
				#Make sure statement PDF links are valid
				expect(Net::HTTP.get_response(URI(statement.attribute("href"))).code_type == Net::HTTPOK).to eql true
			end

			#Check link to adobe site
			wait.until { myaccount.here_link.displayed? }
			js_scroll_up(myaccount.here_link, true)
			myaccount.here_link.click
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "get.adobe.com/reader" }
			#Close tab that was opened
			if ENV['BROWSER_TYPE'] == 'IE'
				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
			else
				$test_driver.execute_script("window.close();")
			end
			$test_driver.switch_to.window( $test_driver.window_handles.first )
		end

		it " - Manage appointments page" do
			$logger.info("Manage appointments page")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("Stateme1", account_password)

			#Navigate to update password page
			myaccount.manage_appointments_link.click
			wait.until { $test_driver.title.include? parsed["my-account"]["manage-appointments"] }

			#TODO: Finish this section once accounts with appointments are available
		end

		it " - My Account (dependant) page" do
			$logger.info("My Account (dependant) page")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("DependentWMA", account_password)

			#Verify differences from guarantor version
			expect(myaccount.my_account_statements_link.displayed?).to eql false

			begin
				#We don't want this
				expect(myaccount.account_info_statements.displayed?).to eql true
			rescue Selenium::WebDriver::Error::NoSuchElementError
				#This is what we want
			else
				fail("Statements link appears on dependant page")
			end
		end

		it " - Make a payment billing address" do
			$logger.info("Make a payment billing address")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			#Open make a payment modal
			begin
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			end

			expect(myaccount.map_billing_info.displayed?).to eql true
			myaccount.map_edit_link.click
			expect(myaccount.map_street_address.displayed?).to eql true
			#Verify required fields
			myaccount.map_street_address.clear
			myaccount.map_city.clear
			myaccount.map_state.clear
			myaccount.map_zip.clear
			myaccount.map_update_address_cta.click
			expect(myaccount.map_street_address.attribute("class").include? "is-error").to eql true
			expect(myaccount.map_city.attribute("class").include? "is-error").to eql true
			expect(myaccount.map_state.attribute("class").include? "is-error").to eql true
			expect(myaccount.map_zip.attribute("class").include? "is-error").to eql true

			#Numbers in city field
			myaccount.map_city.send_keys("12345")
			myaccount.map_update_address_cta.click
			expect(myaccount.map_city.attribute("class").include? "is-error").to eql true

			#Invalid state
			myaccount.map_state.send_keys("ZZ")
			myaccount.map_update_address_cta.click
			expect(myaccount.map_state.attribute("class").include? "is-error").to eql true

			#Invalid zip
			myaccount.map_zip.send_keys("asdfj")
			myaccount.map_update_address_cta.click
			expect(myaccount.map_zip.attribute("class").include? "is-error").to eql true

			#Cancel CTA
			myaccount.map_cancel_address_cta.click
			wait.until { myaccount.map_edit_link.displayed? }
		end

		it " - Make a payment amount validation" do
			$logger.info("Make a payment amount validation")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			#Open make a payment modal
			begin
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			end

			sleep 1
			myaccount.map_other_amount_check.click
			myaccount.map_account_balance_check.click
			myaccount.map_other_amount_check.click
			myaccount.map_other_amount_field.send_keys("asdf")
			myaccount.map_submit_cta.click
			expect(myaccount.map_other_amount_field.attribute("class").include? "is-error").to eql true
			sleep 1
			myaccount.map_other_amount_field.clear
			myaccount.map_other_amount_field.send_keys("6.78")
			myaccount.map_submit_cta.click
			expect(myaccount.map_other_amount_field.attribute("class").include? "is-error").to eql false
		end

		it " - Make a payment billing flow INCOMPLETE" do
			$logger.info("Make a payment billing flow")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			#Open make a payment modal
			begin
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				myaccount.make_a_payment_link.click
				wait.until { myaccount.map_modal.displayed? }
			end

			#Check all dropdown items
			for i in 1 .. 4 
				sleep 1
				#Click dropdown
				myaccount.map_cc_type.click
				#Click dropdown item
				wait.until { myaccount.map_cc_type_item(i).displayed? }
				myaccount.map_cc_type_item(i).click
				#Have to click another element before the next go-around
				js_scroll_up(myaccount.map_cc_picture(1),true)
				wait.until { myaccount.map_cc_picture(1).displayed? }
				myaccount.map_cc_picture(1).click
			end

			# #Invalid CC number
			sleep 1
			myaccount.map_cc_no.send_keys("asl;dkfas;f")
			myaccount.map_submit_cta.click
			wait.until { myaccount.map_cc_no.attribute("class").include? "is-error" }
			#Valid CC number
			sleep 1
			myaccount.map_cc_no.clear
			myaccount.map_cc_no.send_keys("4111111111111111")
			myaccount.map_submit_cta.click
			wait.until { !myaccount.map_cc_no.attribute("class").include? "is-error" }

			#Invalid CVV
			sleep 1
			myaccount.map_cc_cvv.send_keys("asd")
			myaccount.map_submit_cta.click
			wait.until { myaccount.map_cc_cvv_error.displayed? }
			#Valid CVV
			sleep 1
			myaccount.map_cc_cvv_error.clear
			myaccount.map_cc_cvv_error.send_keys("123")
			myaccount.map_submit_cta.click
			wait.until { myaccount.map_cc_cvv.displayed? }

			#Invalid expiration date (defaults to invalid)
			sleep 1
			myaccount.map_submit_cta.click
			wait.until { myaccount.map_cc_date_error.displayed? }
		end

		it " - Account Message DNI" do
			$logger.info("Account Message DNI")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			myaccount.tools_manage_appointments.click
			wait.until { $test_driver.title.include? parsed["my-account"]["manage-appointments"] }

			# if myaccount.ma_phone_number.text != "(877) 929-0874"
			# 	fail("Default DNI number did not match, was instead: " + myaccount.ma_phone_number.text)
			# end
			base_url = $test_driver.current_url
			utm_sources = ["google","yp","yelp","yahoo","bing"]
			dni_numbers = ["(877) 277-4354","(877) 277-4403","(877) 929-0874","(877) 277-4441","(877) 277-4403"]
			for i in 0 .. dni_numbers.length-1
				$test_driver.navigate.to(base_url + "?utm_source=" + utm_sources[i])
				wait.until { myaccount.ma_phone_number.displayed? }
				sleep 1 #Give time for phone no. to switch dynamically
				if myaccount.ma_phone_number.text != dni_numbers[i]
					fail(utm_sources[i] + " DNI number did not match, was instead: " + myaccount.ma_phone_number.text)
				end
			end
		end
	end
end