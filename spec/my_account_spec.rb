# require 'spec_helper'
# require 'test_validation'
# require 'net/http'

# def open_map_modal()
# 	#Open make a payment modal
# 	myaccount = MyAccountPage.new()
# 	wait = Selenium::WebDriver::Wait.new(timeout: 3)
# 	num_retry = 0
# 	begin
# 		js_scroll_up(myaccount.make_a_payment_link)
# 		myaccount.make_a_payment_link.click
# 		wait.until { myaccount.map_modal.displayed? }
# 	rescue Selenium::WebDriver::Error::TimeOutError
# 		num_retry += 1
# 		retry if num_retry == 1
# 		fail("Make a Payment modal failed to open")
# 	end
# end

# describe "My Account functionality" do
# 	myaccount = MyAccountPage.new()
# 	forsee = ForseePage.new()
# 	header = HeaderPage.new()
# 	scroll_sleep_time = 3
# 	wait = Selenium::WebDriver::Wait.new(timeout: 3)
# 	wait_long = Selenium::WebDriver::Wait.new(timeout: 20)
# 	test_val = TestValidation.new()

# 	account_password = "Aspen123!"

# 	describe " - User can use My Account section correctly" do
# 		$logger.info("User can use My Account section correctly")

# 		it " - Sign in page validation" do
# 			$logger.info("Sign in page validaton")
# 			forsee.add_cookies()
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			title = parsed["my-account"]["sign-in"]
# 			#Navigate to page
# 			header.my_account_cta.click
# 			#wait.until { $test_driver.current_url.include? "/my-account/login" }
# 			wait.until { $test_driver.title.include? title }

# 			#Don't have an account tile
# 			expect(myaccount.no_account_container.displayed?).to eql true
# 			test_link_back(myaccount.sign_up_cta, title, parsed["my-account"]["sign-up"])

# 			#Valid username, invalid password
# 			test_val.text_input(myaccount.username_field, "guarantorNDNA")
# 			test_val.text_input(myaccount.password_field, "asdfjkl")
# 			#myaccount.login_form.submit
# 			myaccount.sign_in_cta.click
# 			#test_val.error_msg(myaccount.form_error_msg, true, nil, true)
# 			wait_long.until {myaccount.form_error_msg.displayed? }

# 			#Invalid username, valid password
# 			test_val.text_input(myaccount.username_field, "a")
# 			test_val.text_input(myaccount.password_field, "Valid987$")
# 			#myaccount.login_form.submit
# 			myaccount.sign_in_cta.click
# 			test_val.error_msg(myaccount.form_uname_msg, true)

# 			#Invalid username, invalid password
# 			test_val.text_input(myaccount.username_field, "a")
# 			test_val.text_input(myaccount.password_field, "Valid987$")
# 			#myaccount.login_form.submit
# 			myaccount.sign_in_cta.click
# 			test_val.error_msg(myaccount.form_uname_msg, true)

# 			#Valid username, valid password
# 			test_val.text_input(myaccount.username_field, "guarantorNDNA")
# 			test_val.text_input(myaccount.password_field, account_password)
# 			myaccount.sign_in_cta.click
# 			#myaccount.login_form.submit
# 			Selenium::WebDriver::Wait.new(timeout: 15, message: "My Account page failed to load in time after signing in").until { myaccount.sign_out_link.displayed? }
# 		end

# 		it " - Forgot username flow" do
# 			$logger.info("Forgot username flow")
# 			forsee.add_cookies()
# 			#Navigate to page
# 			header.my_account_cta.click
# 			wait.until { $test_driver.current_url.include? "/my-account/login" }

# 			#Open modal
# 			num_retry = 0
# 			begin
# 				myaccount.forgot_username_link.click
# 				wait.until { myaccount.fu_container.displayed? }
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				#Try again
# 				retry if (num_retry += 1) == 1
# 				fail("Forgot username modal failed to open")
# 			end

# 			#Test required fields
# 			myaccount.fu_submit_cta.click
# 			test_val.batch_check_highlights([myaccount.fu_fname_field, myaccount.fu_lname_field, myaccount.fu_account_no_field], true)

# 			#Invalid account
# 			test_val.text_input(myaccount.fu_fname_field, "FName")
# 			test_val.text_input(myaccount.fu_lname_field, "LName")
# 			test_val.text_input(myaccount.fu_account_no_field, "12345",false,myaccount.fu_submit_cta)
# 			wait.until { myaccount.fu_message.displayed? }
# 			error_msg = myaccount.fu_message.attribute("innerHTML")

# 			#Close/reopen modal
# 			myaccount.fu_close_cta.click
# 			wait_for_disappear(myaccount.fu_message,3)
# 			myaccount.forgot_username_link.click
# 			wait.until { myaccount.fu_container.displayed? }
			
# 			#Valid account
# 			test_val.text_input(myaccount.fu_fname_field, "richard")
# 			test_val.text_input(myaccount.fu_lname_field, "test")
# 			test_val.text_input(myaccount.fu_account_no_field, "1021",false,myaccount.fu_submit_cta)
# 			wait.until { myaccount.fu_message.displayed? }
# 			#Make sure we didn't recieve error message again
# 			expect(myaccount.fu_message.attribute("innerHTML") != error_msg).to eql true
# 		end

# 		it " - Forgot password flow" do
# 			$logger.info("Forgot password flow")
# 			forsee.add_cookies()
# 			#Navigate to page
# 			header.my_account_cta.click
# 			wait.until { $test_driver.current_url.include? "/my-account/login" }

# 			#Open modal
# 			num_retry = 0
# 			begin
# 				myaccount.forgot_password_link.click
# 				wait.until { myaccount.fp_container.displayed? }
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				#Try again
# 				retry if (num_retry += 1) == 1
# 				fail("Forgot password modal failed to open")
# 			end

# 			#Check required field
# 			myaccount.fp_submit_cta.click
# 			wait.until { myaccount.fp_text_field.attribute("class").include? "is-error" }

# 			#Invalid username
# 			test_val.text_input(myaccount.fp_text_field, "asdf",true,myaccount.fp_submit_cta)

# 			#Valid username
# 			test_val.text_input(myaccount.fp_text_field, "guarantorNDNA",false,myaccount.fp_submit_cta)
# 			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

# 			#Invalid security answer
# 			test_val.text_input(myaccount.fp_text_field, "asdf",false,myaccount.fp_submit_cta)
# 			wait.until { myaccount.fp_message.displayed? }

# 			#Close/reopen modal
# 			myaccount.fp_close_cta.click
# 			wait_for_disappear(myaccount.fp_message,3)
# 			myaccount.forgot_password_link.click
# 			wait.until { myaccount.fp_container.displayed? }
# 			test_val.text_input(myaccount.fp_text_field, "guarantorNDNA",false,myaccount.fp_submit_cta)
# 			wait.until { myaccount.fp_text_field.attribute("data-validate") == "security-question-answer" }

# 			#Valid security answer
# 			test_val.text_input(myaccount.fp_text_field, "emerald",false,myaccount.fp_submit_cta)
# 			wait.until { myaccount.fp_password_field.displayed? }

# 			#Two password requirement
# 			test_val.text_input(myaccount.fp_password_field, account_password, false, myaccount.fp_pass_submit_cta)
# 			wait.until { myaccount.fp_error_msg.displayed? }

# 			#Non-matching passwords
# 			test_val.text_input(myaccount.fp_confirm_pass_field, "Aspen1231", true, myaccount.fp_pass_submit_cta)
# 			wait.until { myaccount.fp_error_msg.displayed? }

# 			#Valid passwords
# 			test_val.text_input(myaccount.fp_confirm_pass_field, account_password, false, myaccount.fp_pass_submit_cta)
# 			wait.until { myaccount.fp_reset_message.displayed? }
# 		end

# 		it " - My Account (Guarantor) page" do
# 			$logger.info("My Account (Guarantor) page")
# 			forsee.add_cookies()
# 			fname = "Lee"
# 			lname = "Biddlecome"

# 			myaccount.perform_login("stateme1", account_password)

# 			#Verify elements
# 			expect(myaccount.welcome_text.displayed?).to eql true
# 			expect(myaccount.welcome_text.attribute("innerHTML").include? "Welcome back " + fname).to eql true
# 			expect(myaccount.sign_out_link.displayed?).to eql true
# 			expect(myaccount.holder_info.displayed?).to eql true
# 			expect(myaccount.holder_info.attribute("innerHTML").include? fname + " " + lname).to eql true
# 			expect(myaccount.office_details.displayed?).to eql true
# 			expect(myaccount.empty_notification.displayed?).to eql true

# 			#Test links
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			title = parsed["my-account"]["my-account"]

# 			#Sidebar
# 			test_link_back(myaccount.my_account_sidebar_link, title, title)
# 			test_link_back(myaccount.my_account_statements_link, title, parsed["my-account"]["statements"])
# 			test_link_back(myaccount.manage_appointments_link, title, parsed["my-account"]["manage-appointments"])
# 			test_link_back(myaccount.update_password_link, title, parsed["my-account"]["update-password"])

# 			test_link_back(myaccount.account_info_statements, title, parsed["my-account"]["statements"])

# 			test_link_back(myaccount.tools_manage_appointments, title, parsed["my-account"]["manage-appointments"])

# 			test_link_back(myaccount.profile_update_password_link, title, parsed["my-account"]["update-password"])

# 			#Latest statement pdf
# 			wait.until { myaccount.current_statement.displayed? }
# 			# if ENV['BROWSER_TYPE'] != "FIREFOX" #Firefox doesn't like doing this for some reason
# 			# 	url = myaccount.current_statement.attribute("href").split(".com/")
# 			# 	response = nil
# 			# 	Net::HTTP.start(url[0].split("https://").last + ".com", 80) {|http|
# 			# 		response = http.head("/" + url[1])
# 			# 	}
# 			# 	if(response.code != "200")
# 			# 		fail("Statement link returned code: " + response.code)
# 			# 	end
# 			# end

# 			#Account balance
# 			expect(myaccount.account_balance.displayed?).to eql true
# 		end

# 		it " - Appointment messaging section" do
# 			$logger.info("Appointment messaging section")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 		 	title = parsed["my-account"]["my-account"]

# 			myaccount.perform_login("GuarantorW50", account_password)

# 			#First slide should be showing
# 			wait.until { myaccount.apt_slide(1).displayed? }
# 			#Test next arrow
# 			myaccount.apt_next.click
# 			wait.until { myaccount.apt_slide(2).attribute("class").include? "slick-current"}
# 			#Test prev arrow
# 			sleep 1
# 			myaccount.apt_prev.click
# 			sleep 1
# 			wait.until { myaccount.apt_slide(1).attribute("class").include? "slick-current"}

# 			#Check order of appointments
# 			prev_date = nil
# 			prev_time = nil
# 			prev_ampm = nil
# 			myaccount.apt_wrappers.each do |wrapper|
# 				#Thankfully this tag contains json data for appointment
# 				apt_data = JSON.parse(wrapper.attribute("data-appointment"))
# 				date = apt_data["Date"].split("-") #1 = month, 2 = day
# 				time = apt_data["StartTime"].split(":") #0 = hour, 1 = minute

# 				if prev_date != nil && prev_time != nil
# 					#Build failure string
# 					fail_string = "Appointment " + date[1] + "/" + date[2] + " " + time[0] + ":" + time[1]
# 					fail_string += " appears in wrong order compared to "
# 					fail_string += prev_date[1] + "/" + prev_date[2] + " " + prev_time[0] + ":" + prev_time[1]

# 					#Check for wrong day order, if not new month
# 					if (prev_date[1] == date[1]) && (prev_date[2].to_i > date[2].to_i)
# 						fail(fail_string)
# 					end

# 					#Check for wrong hour order, if not new day
# 					if (prev_date[2] == date[2]) && (prev_time[0].to_i > time[0].to_i)
# 						fail(fail_string)
# 					end

# 					#Check for wrong minute order, if not new hour
# 					if (prev_time[0] == time[0]) && (prev_time[1].to_i > time[1].to_i)
# 						fail(fail_string)
# 					end
# 				end
# 				#For next go-around
# 				prev_date = date
# 				prev_time = time
# 			end

# 			#Click manage appointments link
# 			test_link_back(myaccount.man_apt_link, title, parsed["my-account"]["manage-appointments"])
# 		end

# 		it " - Update password page validation" do
# 			$logger.info("Update password validation")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)

# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			#Navigate to update password page
# 			js_scroll_up(myaccount.update_password_link)
# 			myaccount.update_password_link.click
# 			wait.until { $test_driver.title.include? parsed["my-account"]["update-password"] }

# 			#Valid password, but new pass is less than 8 characters
# 			test_val.text_input(myaccount.pass_old, account_password, false)
# 			test_val.text_input(myaccount.pass_new, "Aa123!", false)
# 			test_val.text_input(myaccount.pass_confirm, "Aa123!", false, myaccount.pass_submit_cta)
# 			test_val.error_msg(myaccount.pass_form_error, true, "at least 8 characters")


# 			#Valid password, but new pass doesn't contain capital letter
# 			test_val.text_input(myaccount.pass_new, "aspen123!", true)
# 			test_val.text_input(myaccount.pass_confirm, "aspen123!", false, myaccount.pass_submit_cta)
# 			test_val.error_msg(myaccount.pass_form_error, true, "at least 1 uppercase letter")


# 			#Valid password, but new pass doesn't contain special character
# 			test_val.text_input(myaccount.pass_new, "Aspen1231", true)
# 			test_val.text_input(myaccount.pass_confirm, "Aspen1231", false, myaccount.pass_submit_cta)
# 			test_val.error_msg(myaccount.pass_form_error, true, "at least 1 special character")
# 		end

# 		it " - Statements page" do
# 			$logger.info("Statements page")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("Stateme1", account_password)

# 			#Navigate to statements page
# 			myaccount.my_account_statements_link.click
# 			wait.until { $test_driver.title.include? parsed["my-account"]["statements"] }

# 			#Check statement PDFs
# 			if ENV['BROWSER_TYPE'] != "FIREFOX" #Firefox doesn't like doing this for some reason
# 				myaccount.statements.each do |statement|
# 					#Split URL
# 					url = statement.attribute("href").split(".com/")
# 					response = nil
# 					Net::HTTP.start(url[0].split("https://").last + ".com", 80) {|http|
# 						response = http.head("/" + url[1])
# 					}
# 					if(response.code != "200")
# 						fail("Statement link returned code: " + response.code)
# 					end
# 				end
# 			end

# 			#Check link to adobe site
# 			wait.until { myaccount.here_link.displayed? }
# 			js_scroll_up(myaccount.here_link, true)
# 			test_link_tab(myaccount.here_link, nil, "get.adobe.com/reader")
# 		end

# 		it " - Appointments page (no appointments)" do
# 			$logger.info("Appointments page (no appointments)")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)

# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			#Navigate to appointments page
# 			myaccount.manage_appointments_link.click
# 			wait.until { $test_driver.title.include? parsed["my-account"]["manage-appointments"] }

# 			#Verify no appointments message
# 			expect(myaccount.no_appointments.displayed?).to eql true
# 			expect(myaccount.no_appointments.attribute("innerHTML").include? "Our records indicate that you don't have any upcoming appointments.").to eql true
# 		end

# 		it " - Appointments page (with appointments)" do
# 			$logger.info("Appointments page (with appointments)")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)

# 			myaccount.perform_login("GuarantorW50", account_password)

# 			#Navigate to appointments page
# 			myaccount.manage_appointments_link.click
# 			wait.until { $test_driver.title.include? parsed["my-account"]["manage-appointments"] }

# 			#Verify elements
# 			expect(myaccount.no_of_apt.displayed?).to eql true
# 			expect(myaccount.reschedule_ctas.length > 0).to eql true
# 			expect(myaccount.cancel_links.length > 0).to eql true
# 			expect(myaccount.apt_data_containers.length > 0).to eql true
# 		end

# 		it " - Reschedule appointment" do
# 			$logger.info("Reschedule appointment")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			title = parsed["my-account"]["manage-appointments"]
# 			myaccount.perform_login("GuarantorW50", account_password)

# 			#Verify reschedule cta on my account page
# 			expect(myaccount.reschedule_cta.displayed?).to eql true

# 			#Navigate to manage appointments page
# 			js_scroll_up(myaccount.manage_appointments_link)
# 			myaccount.manage_appointments_link.click
# 			wait.until { $test_driver.title.include? title }

# 			#Pick a random appointment
# 			apt_no = rand(0 .. myaccount.reschedule_ctas.length)
# 			test_link_back(myaccount.reschedule_office_links[apt_no],title,parsed["office"]["about-office"])

# 			#Open modal
# 			expect(myaccount.reschedule_ctas[apt_no].displayed?).to eql true
# 			myaccount.reschedule_ctas[apt_no].click
# 			wait.until { myaccount.reschedule_modal.displayed? }

# 			#Verify elements
# 			expect(myaccount.reschedule_header.attribute("innerHTML").include? "Reschedule an appointment").to eql true
# 			expect(myaccount.reschedule_apt_name.displayed?).to eql true
# 			expect(myaccount.reschedule_apt_patient_info.displayed?).to eql true
# 			expect(myaccount.reschedule_office_details.attribute("innerHTML").include? "Your Office:").to eql true

# 			#Verify X to close modal
# 			expect(myaccount.reschedule_x.displayed?).to eql true
# 			sleep 1
# 			myaccount.reschedule_x.click
# 			wait_for_disappear(myaccount.reschedule_modal)

# 			#Re-open modal
# 			expect(myaccount.reschedule_ctas[apt_no].displayed?).to eql true
# 			myaccount.reschedule_ctas[apt_no].click
# 			wait.until { myaccount.reschedule_modal.displayed? }

# 			#Wait until days are displayed
# 			wait_long.until { myaccount.reschedule_day_header.displayed? }
# 			#Click all days
# 			for i in 1 .. 5
# 				for j in 1 .. 7
# 					begin
# 						myaccount.reschedule_days(i,j).click
# 					#Account for unavailable days
# 					rescue Selenium::WebDriver::Error::NoSuchElementError
# 						next
# 					end
# 					wait.until { myaccount.reschedule_days(i,j).attribute("class").include? "ui-state-active" }
# 				end
# 			end

# 			#Click all times
# 			wait.until { myaccount.reschedule_time_header.displayed? }

# 			for i in 1 .. 9
# 				for j in 1 .. 2
# 					begin
# 						myaccount.reschedule_times(i,j).click
# 					#Account for unavailable times
# 					rescue Selenium::WebDriver::Error::NoSuchElementError
# 						next
# 					end
# 					wait.until { myaccount.reschedule_times(i,j).attribute("class").include? "is-selected" }
# 				end
# 			end

# 			#Submit and check success
# 			myaccount.reschedule_submit_cta.click
# 			wait_long.until { myaccount.reschedule_apt_time.displayed? }
# 		end

# 		it " - Reschedule success modal" do
# 			$logger.info("Reschedule success modal")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			title = parsed["my-account"]["manage-appointments"]
# 			myaccount.perform_login("GuarantorW50", account_password)

# 			for i in 0 .. 1
# 				myaccount.reschedule_cta.click
# 				wait.until { myaccount.reschedule_modal.displayed? }
# 				wait_long.until { myaccount.reschedule_time_header.displayed? }
# 				sleep 3
# 				myaccount.reschedule_submit_cta.click
# 				wait_long.until { myaccount.confirm_message.displayed? }

# 				if i == 0
# 					myaccount.reschedule_x.click
# 					begin
# 						wait.until { !myaccount.reschedule_modal.displayed? }
# 					rescue Selenium::WebDriver::Error::TimeOutError
# 						#Good
# 					end
# 					sleep 3
# 				end
# 			end

# 			#Verify elements
# 			expect(myaccount.reschedule_header.attribute("innerHTML").include? "Reschedule an appointment").to eql true
# 			expect(myaccount.confirm_message.attribute("innerHTML").include? "Thank you for your request. We'll send a confirmation email").to eql true
# 			expect(myaccount.confirm_subtitle.attribute("innerHTML").include? "New Appointment Details").to eql true
# 			expect((myaccount.reschedule_apt_time.attribute("innerHTML").include? "PM") || (myaccount.reschedule_apt_time.attribute("innerHTML").include? "AM")).to eql true
# 			expect(myaccount.reschedule_office_details.displayed?).to eql true

# 			#Check links
# 			test_link_tab(myaccount.reschedule_google_cal_link,"Calendar")
# 			test_link_tab(myaccount.reschedule_google_map_link,"Google Maps")

# 			#Close modal
# 			myaccount.reschedule_close_cta.click
# 			begin
# 				wait_for_disappear(myaccount.reschedule_apt_time, 4)
# 			rescue Selenium::WebDriver::Error::NoSuchElementError
# 				#This is what we want
# 			end
# 		end

# 		it " - Cancel appointment modal" do
# 			$logger.info("Cancel appointment modal")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			title = parsed["my-account"]["manage-appointments"]
# 			myaccount.perform_login("GuarantorW50", account_password)

# 			#Verify cancel link on my account page
# 			wait.until { myaccount.cancel_links[0].displayed? }
# 			myaccount.cancel_links[0].click
# 			wait.until { myaccount.cancel_modal.displayed? }
# 			#Verify elements
# 			expect(myaccount.cancel_modal_header.attribute("innerHTML").include? "Cancel an appointment").to eql true
# 			expect(myaccount.cancel_copy.attribute("innerHTML").include? "Are you sure you want to cancel the following appointment?").to eql true
# 			expect(myaccount.cancel_apt_details.attribute("innerHTML").include? "Appointment details").to eql true
# 			expect(myaccount.cancel_yes_copy.attribute("innerHTML").include? "Yes, I want to cancel my appointment").to eql true
# 			expect(myaccount.cancel_reason_question.attribute("innerHTML").include? "What was the primary reason for cancelling your appointment?").to eql true
# 			expect(myaccount.cancel_required_message.attribute("innerHTML").include? "Required Field").to eql true
# 			#Verify appointment details
# 			expect(myaccount.cancel_apt_time.displayed?).to eql true
# 			#Verify office details
# 			expect(myaccount.cancel_office_details.displayed?).to eql true
# 			#Verify X to close modal
# 			myaccount.cancel_modal_x.click
# 			begin
# 				wait_for_disappear(myaccount.cancel_modal,3)
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				#Good
# 			end
# 			sleep 1

# 			#Navigate to manage accounts page
# 			js_scroll_up(myaccount.manage_appointments_link)
# 			myaccount.manage_appointments_link.click
# 			wait.until { $test_driver.title.include? title }

# 			#Pick a random appointment
# 			apt_no = rand(0 .. myaccount.reschedule_ctas.length)
# 			#Open modal
# 			js_scroll_up(myaccount.cancel_links[apt_no])
# 			myaccount.cancel_links[apt_no].click
# 			wait.until { myaccount.cancel_modal.displayed? }

# 			#Attempt to submit without selecting reason
# 			sleep 1
# 			myaccount.cancel_submit.click
# 			wait.until { myaccount.cancel_reason_dropdown.attribute("style").include? "border-color: red"} #Doesn't use the 'is-error' class for some reason?

# 			#Click all reasons
# 			sleep 1
# 			options = ["A","B","C","D","E","F"]
# 			for i in 0 .. options.length-1
# 				myaccount.cancel_reason_dropdown.click
# 				myaccount.cancel_reason_dropdown_items(options[i]).click
# 				expect(myaccount.cancel_reason_dropdown_items(options[i]).attribute("aria-selected") == "true").to eql true
# 			end

# 			#Close modal
# 			myaccount.cancel_close_link.click
# 			begin
# 				wait_for_disappear(myaccount.cancel_modal,3)
# 			rescue Selenium::WebDriver::Error::NoSuchElementError
# 				#This is what we want
# 			end

# 			#Re-open modal
# 			js_scroll_up(myaccount.cancel_links[apt_no])
# 			myaccount.cancel_links[apt_no].click
# 			wait.until { myaccount.cancel_modal.displayed? }

# 			#Click reschedule CTA
# 			sleep 1
# 			myaccount.cancel_reschedule_cta.click
# 			wait.until { myaccount.reschedule_modal.displayed? }
# 		end

# 		it " - My Account (dependant) page" do
# 			$logger.info("My Account (dependant) page")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("DependentWMA", account_password)

# 			#Verify differences from guarantor version
# 			expect(myaccount.my_account_statements_link.displayed?).to eql false

# 			begin
# 				#We don't want this
# 				expect(myaccount.account_info_statements.displayed?).to eql true
# 			rescue Selenium::WebDriver::Error::NoSuchElementError
# 				#This is what we want
# 			else
# 				fail("Statements link appears on dependant page")
# 			end

# 			#Make sure we can't manually navigate to statements page
# 			$test_driver.navigate.to($test_driver.current_url + "/statements")
# 			wait.until { $test_driver.title.include? parsed["my-account"]["my-account"] }
# 		end

# 		it " - Make a payment billing address" do
# 			$logger.info("Make a payment billing address")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			open_map_modal()

# 			expect(myaccount.map_billing_info.displayed?).to eql true
			
# 			num_retry = 0
# 			begin
# 				myaccount.map_edit_link.click
# 				wait.until { myaccount.map_street_address.displayed? }
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				#Try again (thanks chrome!)
# 				retry if (num_retry += 1) == 1
# 			end
# 			#Verify required fields
# 			myaccount.map_street_address.clear
# 			myaccount.map_city.clear
# 			myaccount.map_state.clear
# 			myaccount.map_zip.clear
# 			myaccount.map_update_address_cta.click
# 			test_val.batch_check_highlights([myaccount.map_street_address,myaccount.map_city,myaccount.map_state,myaccount.map_zip])

# 			#Numbers in city field
# 			test_val.text_input(myaccount.map_city, "12345", true, myaccount.map_update_address_cta)

# 			#Invalid state
# 			test_val.text_input(myaccount.map_state, "ZZ", true, myaccount.map_update_address_cta)

# 			#Invalid zip
# 			test_val.text_input(myaccount.map_zip, "asdfj", true, myaccount.map_update_address_cta)

# 			#Cancel CTA
# 			myaccount.map_cancel_address_cta.click
# 			wait.until { myaccount.map_edit_link.displayed? }
# 		end

# 		it " - Make a payment amount validation" do
# 			$logger.info("Make a payment amount validation")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			open_map_modal()

# 			sleep 1
# 			myaccount.map_other_amount_check.click
# 			myaccount.map_account_balance_check.click
# 			myaccount.map_other_amount_check.click
# 			test_val.text_input(myaccount.map_other_amount_field, "asdf", true, myaccount.map_submit_cta)
# 			sleep 1
# 			test_val.text_input(myaccount.map_other_amount_field, "6.78", false, myaccount.map_submit_cta)

# 			#Click X in top right of modal
# 			sleep 1
# 			js_scroll_up(myaccount.map_modal_x,true)
# 			myaccount.map_modal_x.click
# 			sleep 1
# 			begin
# 				expect(myaccount.map_modal.displayed?).to eql false
# 			rescue Selenium::WebDriver::Error::NoSuchElementError
# 				#This is what we want
# 			end
# 		end

# 		it " - Make a payment billing validation" do
# 			$logger.info("Make a payment billing ")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			open_map_modal()

# 			#Check all credit card types dropdown items
# 			cards = ["Visa","MasterCard","AmEx","Discover"]
# 			for i in 0 .. cards.length-1
# 				sleep 1
# 				#Click dropdown
# 				myaccount.map_cc_type.click
# 				#Click dropdown item
# 				wait.until { myaccount.map_cc_type_item(cards[i]).displayed? }
# 				myaccount.map_cc_type_item(cards[i]).click
# 				#Have to click another element before the next go-around
# 				js_scroll_up(myaccount.map_cc_picture(1),true)
# 				wait.until { myaccount.map_cc_picture(1).displayed? }
# 				myaccount.map_cc_picture(1).click
# 			end

# 			# #Invalid CC number
# 			sleep 1
# 			test_val.text_input(myaccount.map_cc_no,"asl;dkfas;f", true, myaccount.map_submit_cta)
# 			#Valid CC number
# 			sleep 1
# 			test_val.text_input(myaccount.map_cc_no,"4111111111111111", false, myaccount.map_submit_cta)

# 			#Invalid CVV
# 			sleep 1
# 			test_val.text_input(myaccount.map_cc_cvv, "asd", true, myaccount.map_submit_cta)
# 			#Valid CVV
# 			sleep 1
# 			test_val.text_input(myaccount.map_cc_cvv, "123", false, myaccount.map_submit_cta)

# 			#Invalid expiration date (defaults to invalid)
# 			sleep 1
# 			num_retry = 0
# 			begin
# 				myaccount.map_submit_cta.click
# 				wait.until { myaccount.map_cc_date_error.displayed? }
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				retry if (num_retry += 1) == 1
# 			end
# 			#Valid expiration date
# 			sleep 1
# 			myaccount.map_cc_month.click
# 			wait.until { myaccount.map_cc_month_item("02").displayed? }
# 			myaccount.map_cc_month_item("02").click
# 			myaccount.map_cc_year.click
# 			next_year = Date.today.year + 1
# 			wait.until { myaccount.map_cc_year_item(next_year).displayed? }
# 			myaccount.map_cc_year_item(next_year).click
# 			myaccount.map_submit_cta.click
# 			begin
# 				wait.until { myaccount.map_cc_date_error.displayed? }
# 				fail("Invalid year error still displayed after entering valid year")
# 			rescue Selenium::WebDriver::Error::TimeOutError
# 				#This is what we want
# 			end

# 		end

# 		it " - Account Message DNI" do
# 			$logger.info("Account Message DNI")
# 			forsee.add_cookies();
# 			parsed = JSON.parse(open("spec/page_titles.json").read)
# 			myaccount.perform_login("guarantorNDNA", account_password)

# 			myaccount.tools_manage_appointments.click
# 			wait.until { $test_driver.title.include? parsed["my-account"]["manage-appointments"] }

# 			# if myaccount.ma_phone_number.text != "(877) 929-0874"
# 			# 	fail("Default DNI number did not match, was instead: " + myaccount.ma_phone_number.text)
# 			# end
# 			base_url = $test_driver.current_url
# 			utm_sources = ["google","yp","yelp","yahoo","bing"]
# 			dni_numbers = ["(877) 277-4354","(877) 277-4403","(877) 929-0874","(877) 277-4441","(877) 277-4403"]
# 			for i in 0 .. dni_numbers.length-1
# 				$test_driver.navigate.to(base_url + "?utm_source=" + utm_sources[i])
# 				wait.until { myaccount.ma_phone_number.displayed? }
# 				sleep 1 #Give time for phone no. to switch dynamically
# 				if myaccount.ma_phone_number.text != dni_numbers[i]
# 					fail(utm_sources[i] + " DNI number did not match, was instead: " + myaccount.ma_phone_number.text)
# 				end
# 			end
# 		end


# 	end
# end