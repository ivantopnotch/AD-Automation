require 'spec_helper'
require 'test_validation'
require 'net/http'

def login(username, password)
	myaccount = MyAccountPage.new()
	header = HeaderPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	wait_long = Selenium::WebDriver::Wait.new(timeout: 7)
	test_val = TestValidation.new()

	header.my_account_cta.click
	wait.until { $test_driver.current_url.include? "/my-account/login" }
	
	num_retry = 0
	begin
		test_val.text_input(myaccount.username_field, username, false)
		test_val.text_input(myaccount.password_field, password, false)
		myaccount.login_form.submit
		wait_long.until { myaccount.make_a_payment_link.displayed? }
	rescue Selenium::WebDriver::Error::TimeOutError
		#Try again (thanks chrome)
		sleep 1
		retry if (num_retry += 1) == 1
		fail("Failed to login as user: " + username + " Pass: " + password)
	end
end

def open_map_modal()
	#Open make a payment modal
	myaccount = MyAccountPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	num_retry = 0
	begin
		js_scroll_up(myaccount.make_a_payment_link)
		myaccount.make_a_payment_link.click
		wait.until { myaccount.map_modal.displayed? }
	rescue Selenium::WebDriver::Error::TimeOutError
		num_retry += 1
		retry if num_retry == 1
		fail("Make a Payment modal failed to open")
	end
end

describe "My Account functionality" do
	myaccount = MyAccountPage.new()
	forsee = ForseePage.new()
	header = HeaderPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	wait_long = Selenium::WebDriver::Wait.new(timeout: 20)
	test_val = TestValidation.new()

	account_password = "Aspen123!"

	describe " - User can use My Account section correctly" do
		$logger.info("User can use My Account section correctly")

		it " - Sign in page validation" do
			$logger.info("Sign in page validaton")
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }

			#Valid username, invalid password
			test_val.text_input(myaccount.username_field, "guarantorNDNA")
			test_val.text_input(myaccount.password_field, "asdfjkl")
			myaccount.login_form.submit
			#test_val.error_msg(myaccount.form_error_msg, true, nil, true)
			wait_long.until {myaccount.form_error_msg.displayed? }

			#Invalid username, valid password
			test_val.text_input(myaccount.username_field, "a")
			test_val.text_input(myaccount.password_field, "Valid987$")
			myaccount.login_form.submit
			test_val.error_msg(myaccount.form_uname_msg, true)

			#Invalid username, invalid password
			test_val.text_input(myaccount.username_field, "a")
			test_val.text_input(myaccount.password_field, "Valid987$")
			myaccount.login_form.submit
			test_val.error_msg(myaccount.form_uname_msg, true)

			#Valid username, valid password
			test_val.text_input(myaccount.username_field, "guarantorNDNA")
			test_val.text_input(myaccount.password_field, account_password)
			#myaccount.sign_in_cta.click
			myaccount.login_form.submit
			Selenium::WebDriver::Wait.new(timeout: 15, message: "My Account page failed to load in time after signing in").until { myaccount.sign_out_link.displayed? }
		end

		it " - Forgot username flow" do
			$logger.info("Forgot username flow")
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }

			#Open modal
			num_retry = 0
			begin
				myaccount.forgot_username_link.click
				wait.until { myaccount.fu_container.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				num_retry += 1
				retry if num_retry == 1
				fail("Forgot username modal failed to open")
			end

			#Test required fields
			myaccount.fu_submit_cta.click
			test_val.batch_check_highlights([myaccount.fu_fname_field, myaccount.fu_lname_field, myaccount.fu_account_no_field], true)

			#Invalid account
			test_val.text_input(myaccount.fu_fname_field, "FName")
			test_val.text_input(myaccount.fu_lname_field, "LName")
			test_val.text_input(myaccount.fu_account_no_field, "12345",false,myaccount.fu_submit_cta)
			wait.until { myaccount.fu_message.displayed? }
			error_msg = myaccount.fu_message.attribute("innerHTML")

			#Close/reopen modal
			myaccount.fu_close_cta.click
			wait_for_disappear(myaccount.fu_message,3)
			myaccount.forgot_username_link.click
			wait.until { myaccount.fu_container.displayed? }
			
			#Valid account
			test_val.text_input(myaccount.fu_fname_field, "richard")
			test_val.text_input(myaccount.fu_lname_field, "test")
			test_val.text_input(myaccount.fu_account_no_field, "1021",false,myaccount.fu_submit_cta)
			wait.until { myaccount.fu_message.displayed? }
			#Make sure we didn't recieve error message again
			expect(myaccount.fu_message.attribute("innerHTML") != error_msg).to eql true
		end

		it " - Forgot password flow" do
			$logger.info("Forgot password flow")
			forsee.add_cookies()
			#Navigate to page
			header.my_account_cta.click
			wait.until { $test_driver.current_url.include? "/my-account/login" }

			#Open modal
			num_retry = 0
			begin
				myaccount.forgot_password_link.click
				wait.until { myaccount.fp_container.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again
				num_retry += 1
				retry if num_retry == 1
				fail("Forgot password modal failed to open")
			end

			#Check required field
			myaccount.fp_submit_cta.click
			wait.until { myaccount.fp_text_field.attribute("class").include? "is-error" }

			#Invalid username
			test_val.text_input(myaccount.fp_text_field, "asdf",true,myaccount.fp_submit_cta)

			#Valid username
			test_val.text_input(myaccount.fp_text_field, "guarantorNDNA",false,myaccount.fp_submit_cta)
			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

			#Invalid security answer
			test_val.text_input(myaccount.fp_text_field, "asdf",false,myaccount.fp_submit_cta)
			wait.until { myaccount.fp_message.displayed? }

			#Close/reopen modal
			myaccount.fp_close_cta.click
			wait_for_disappear(myaccount.fp_message,3)
			myaccount.forgot_password_link.click
			wait.until { myaccount.fp_container.displayed? }
			test_val.text_input(myaccount.fp_text_field, "guarantorNDNA",false,myaccount.fp_submit_cta)
			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

			#Valid security answer
			test_val.text_input(myaccount.fp_text_field, "emerald",false,myaccount.fp_submit_cta)
			wait.until { myaccount.fp_password_field.displayed? }

			#Two password requirement
			test_val.text_input(myaccount.fp_password_field, account_password, false, myaccount.fp_pass_submit_cta)
			wait.until { myaccount.fp_error_msg.displayed? }

			#Non-matching passwords
			test_val.text_input(myaccount.fp_confirm_pass_field, "Aspen1231", true, myaccount.fp_pass_submit_cta)
			wait.until { myaccount.fp_error_msg.displayed? }

			#Valid passwords
			test_val.text_input(myaccount.fp_confirm_pass_field, account_password, false, myaccount.fp_pass_submit_cta)
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
			js_scroll_up(myaccount.update_password_link)
			myaccount.update_password_link.click
			wait.until { $test_driver.title.include? parsed["my-account"]["update-password"] }

			#Valid password, but new pass is less than 8 characters
			test_val.text_input(myaccount.pass_old, account_password, false)
			test_val.text_input(myaccount.pass_new, "Aa123!", false)
			test_val.text_input(myaccount.pass_confirm, "Aa123!", false, myaccount.pass_submit_cta)
			test_val.error_msg(myaccount.pass_form_error, true, "at least 8 characters")


			#Valid password, but new pass doesn't contain capital letter
			test_val.text_input(myaccount.pass_new, "aspen123!", true)
			test_val.text_input(myaccount.pass_confirm, "aspen123!", false, myaccount.pass_submit_cta)
			test_val.error_msg(myaccount.pass_form_error, true, "at least 1 uppercase letter")


			#Valid password, but new pass doesn't contain special character
			test_val.text_input(myaccount.pass_new, "Aspen1231", true)
			test_val.text_input(myaccount.pass_confirm, "Aspen1231", false, myaccount.pass_submit_cta)
			test_val.error_msg(myaccount.pass_form_error, true, "at least 1 special character")
		end

		it " - Statements page" do
			$logger.info("Statements page")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("Stateme1", account_password)

			#Navigate to update password page
			myaccount.my_account_statements_link.click
			wait.until { $test_driver.title.include? parsed["my-account"]["statements"] }

			#Check statement PDFs
			if ENV['BROWSER_TYPE'] != "firefox" #Firefox doesn't like doing this for some reason
				myaccount.statements.each do |statement|
					#Split URL
					url = statement.attribute("href").split(".com/")
					response = nil
					Net::HTTP.start(url[0].split("https://").last + ".com", 80) {|http|
						response = http.head("/" + url[1])
					}
					if(response.code != "200")
						fail("Statement link returned code: " + response.code)
					end
				end
			end

			#Check link to adobe site
			wait.until { myaccount.here_link.displayed? }
			js_scroll_up(myaccount.here_link, true)
			test_link_tab(myaccount.here_link, nil, "get.adobe.com/reader")
		end

		it " - Reschedule appointment" do
			$logger.info("Reschedule appointment")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["my-account"]["manage-appointments"]
			login("GuarantorW50", account_password)

			#Verify reschedule cta
			expect(myaccount.reschedule_cta.displayed?).to eql true

			#Navigate to page
			js_scroll_up(myaccount.manage_appointments_link)
			myaccount.manage_appointments_link.click
			wait.until { $test_driver.title.include? title }

			#Pick a random appointment
			apt_no = rand(0 .. myaccount.reschedule_ctas.length)
			test_link_back(myaccount.reschedule_office_links[apt_no],title,parsed["office"]["about-office"])

			#Open modal
			expect(myaccount.reschedule_ctas[apt_no].displayed?).to eql true
			myaccount.reschedule_ctas[apt_no].click
			wait.until { myaccount.reschedule_modal.displayed? }

			#Wait until days are displayed
			wait_long.until { myaccount.reschedule_day_header.displayed? }
			#Click all days
			for i in 1 .. 5
				for j in 1 .. 7
					begin
						myaccount.reschedule_days(i,j).click
					#Account for unavailable days
					rescue Selenium::WebDriver::Error::NoSuchElementError
						next
					end
					wait.until { myaccount.reschedule_days(i,j).attribute("class").include? "ui-state-active" }
				end
			end

			#Click all times
			wait.until { myaccount.reschedule_time_header.displayed? }

			for i in 1 .. 9
				for j in 1 .. 2
					begin
						myaccount.reschedule_times(i,j).click
					#Account for unavailable times
					rescue Selenium::WebDriver::Error::NoSuchElementError
						next
					end
					wait.until { myaccount.reschedule_times(i,j).attribute("class").include? "is-selected" }
				end
			end

			#Submit and check success
			myaccount.reschedule_submit_cta.click
			wait_long.until { myaccount.reschedule_apt_time.displayed? }

			#Check links
			test_link_tab(myaccount.reschedule_google_cal_link,"Calendar")
			test_link_tab(myaccount.reschedule_google_map_link,"Google Maps")

			#Close modal
			myaccount.reschedule_close_cta.click
			begin
				wait_for_disappear(myaccount.reschedule_apt_time, 4)
			rescue Selenium::WebDriver::Error::NoSuchElementError
				#This is what we want
			end
		end

		it " - Cancel appointment modal" do
			$logger.info("Cancel appointment modal")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["my-account"]["manage-appointments"]
			login("GuarantorW50", account_password)

			#Navigate to page
			js_scroll_up(myaccount.manage_appointments_link)
			myaccount.manage_appointments_link.click
			wait.until { $test_driver.title.include? title }

			#Pick a random appointment
			apt_no = rand(0 .. myaccount.reschedule_ctas.length)
			#Open modal
			js_scroll_up(myaccount.cancel_links[apt_no])
			myaccount.cancel_links[apt_no].click
			wait.until { myaccount.cancel_modal.displayed? }

			#Click all reasons
			sleep 1
			options = ["A","B","C","D","E","F"]
			for i in 0 .. options.length-1
				myaccount.cancel_reason_dropdown.click
				myaccount.cancel_reason_dropdown_items(options[i]).click
				expect(myaccount.cancel_reason_dropdown_items(options[i]).attribute("aria-selected") == "true").to eql true
			end

			#Close modal
			myaccount.cancel_close_link.click
			begin
				wait_for_disappear(myaccount.cancel_modal,3)
			rescue Selenium::WebDriver::Error::NoSuchElementError
				#This is what we want
			end

			#Re-open modal
			js_scroll_up(myaccount.cancel_links[apt_no])
			myaccount.cancel_links[apt_no].click
			wait.until { myaccount.cancel_modal.displayed? }

			#Click reschedule CTA
			sleep 1
			myaccount.cancel_reschedule_cta.click
			wait.until { myaccount.reschedule_modal.displayed? }
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

			open_map_modal()

			expect(myaccount.map_billing_info.displayed?).to eql true
			
			num_retry = 0
			begin
				myaccount.map_edit_link.click
				wait.until { myaccount.map_street_address.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				#Try again (thanks chrome!)
				retry if (num_retry += 1) == 1
			end
			#Verify required fields
			myaccount.map_street_address.clear
			myaccount.map_city.clear
			myaccount.map_state.clear
			myaccount.map_zip.clear
			myaccount.map_update_address_cta.click
			test_val.batch_check_highlights([myaccount.map_street_address,myaccount.map_city,myaccount.map_state,myaccount.map_zip])

			#Numbers in city field
			test_val.text_input(myaccount.map_city, "12345", true, myaccount.map_update_address_cta)

			#Invalid state
			test_val.text_input(myaccount.map_state, "ZZ", true, myaccount.map_update_address_cta)

			#Invalid zip
			test_val.text_input(myaccount.map_zip, "asdfj", true, myaccount.map_update_address_cta)

			#Cancel CTA
			myaccount.map_cancel_address_cta.click
			wait.until { myaccount.map_edit_link.displayed? }
		end

		it " - Make a payment amount validation" do
			$logger.info("Make a payment amount validation")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			open_map_modal()

			sleep 1
			myaccount.map_other_amount_check.click
			myaccount.map_account_balance_check.click
			myaccount.map_other_amount_check.click
			test_val.text_input(myaccount.map_other_amount_field, "asdf", true, myaccount.map_submit_cta)
			sleep 1
			test_val.text_input(myaccount.map_other_amount_field, "6.78", false, myaccount.map_submit_cta)
		end

		it " - Make a payment billing validation" do
			$logger.info("Make a payment billing ")
			forsee.add_cookies();
			parsed = JSON.parse(open("spec/page_titles.json").read)
			login("guarantorNDNA", account_password)

			open_map_modal()

			#Check all credit card types dropdown items
			cards = ["Visa","MasterCard","AmEx","Discover"]
			for i in 0 .. cards.length-1
				sleep 1
				#Click dropdown
				myaccount.map_cc_type.click
				#Click dropdown item
				wait.until { myaccount.map_cc_type_item(cards[i]).displayed? }
				myaccount.map_cc_type_item(cards[i]).click
				#Have to click another element before the next go-around
				js_scroll_up(myaccount.map_cc_picture(1),true)
				wait.until { myaccount.map_cc_picture(1).displayed? }
				myaccount.map_cc_picture(1).click
			end

			# #Invalid CC number
			sleep 1
			test_val.text_input(myaccount.map_cc_no,"asl;dkfas;f", true, myaccount.map_submit_cta)
			#Valid CC number
			sleep 1
			test_val.text_input(myaccount.map_cc_no,"4111111111111111", false, myaccount.map_submit_cta)

			#Invalid CVV
			sleep 1
			test_val.text_input(myaccount.map_cc_cvv, "asd", true, myaccount.map_submit_cta)
			#Valid CVV
			sleep 1
			test_val.text_input(myaccount.map_cc_cvv, "123", false, myaccount.map_submit_cta)

			#Invalid expiration date (defaults to invalid)
			sleep 1
			num_retry = 0
			begin
				myaccount.map_submit_cta.click
				wait.until { myaccount.map_cc_date_error.displayed? }
			rescue Selenium::WebDriver::Error::TimeOutError
				retry if (num_retry += 1) == 1
			end
			#Valid expiration date
			sleep 1
			myaccount.map_cc_month.click
			wait.until { myaccount.map_cc_month_item("02").displayed? }
			myaccount.map_cc_month_item("02").click
			myaccount.map_cc_year.click
			next_year = Date.today.year + 1
			wait.until { myaccount.map_cc_year_item(next_year).displayed? }
			myaccount.map_cc_year_item(next_year).click
			myaccount.map_submit_cta.click
			begin
				wait.until { myaccount.map_cc_date_error.displayed? }
				fail("Invalid year error still displayed after entering valid year")
			rescue Selenium::WebDriver::Error::TimeOutError
				#This is what we want
			end

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