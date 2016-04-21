require 'spec_helper'
require 'net/http'

# We test abandonment modal multiple times, so let's make this re-usable
def test_abandon_modal(step_no, saa)
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	$logger.info("Step " + step_no.to_s + " abandonment modal")
	#Make sure abandonment modal appears/closes correctly
	wait.until { saa.logo_link.displayed? }
	saa.logo_link.click
	wait.until { saa.abandonment_modal.displayed? }
	wait.until { saa.close_abandon_modal.displayed? }
	saa.close_abandon_modal.click
	# Wait for modal to disappaer
	wait_for_disappear(saa.abandonment_modal, 3)
end

describe "'Schedule An Appointment' page functionality" do
	header = HeaderPage.new()
	saa = SaaPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	wait_longer = Selenium::WebDriver::Wait.new(timeout: 15)

	describe " - User can schedule an appointment correctly" do
		$logger.info("User can schedule an appointment correctly")

		it " - SAA page" do
			$logger.info("SAA CTA")
			#Click SAA link
			header.saa_cta.click
			wait.until { $test_driver.title.include? "Schedule a Dentist Appointment" }
			sleep scroll_sleep_time

			test_abandon_modal(1, saa)

			$logger.info("Step 1 yes CTA")
			wait.until { saa.yes_cta.displayed? }
			saa.yes_cta.click

			test_abandon_modal(2, saa)

			$logger.info("Step 2 past exam")
			#Click 'yes' under "Has this patient had an exam with us in the past?"; check for disclaimer
			wait.until { saa.past_exam_yes.displayed? }
			saa.past_exam_yes.click
			wait.until { saa.past_exam_disclaimer.displayed? }

			#Click 'no' under "Has this patient had an exam with us in the past?"
			wait.until { saa.past_exam_no.displayed? }
			saa.past_exam_no.click

			$logger.info("Step 2 how old")
			#Click "Under 18" under "How old is the patient?"; check for disclaimer
			wait.until { saa.how_old_under_18.displayed? }
			saa.how_old_under_18.click
			wait.until { saa.age_disclaimer.displayed? }

			#Click "18 or older" under "How old is the patient?"
			wait.until { saa.how_old_over_18.displayed? }
			saa.how_old_over_18.click

			$logger.info("Step 2 primary reason")
			# Make sure we can't go to next step without picking a reason
			wait.until { saa.next_step.displayed? }
			saa.next_step.click
			wait.until { saa.reason_error.displayed? }

			# Click on "Select primary reason" and choose first item
			wait.until { saa.primary_reason_dropdown.displayed? }
			saa.primary_reason_dropdown.click

			item = saa.primary_reason_item
			wait.until { item.displayed? }
			js_scroll_up(saa.primary_reason_item)
			item.click

			$logger.info("'Step 2 Why do we ask' boxes")
			#Click 'Why do we ask' links and make sure shadowboxes appear; do it in reverse order
			wait.until { saa.iae_why_link.displayed? }
			js_scroll_up(saa.iae_why_link,true)
			saa.iae_why_link.click
			wait.until { saa.iae_why_box.displayed? }

			wait.until { saa.isp_why_link.displayed? }
			js_scroll_up(saa.isp_why_link,true)
			saa.isp_why_link.click
			wait.until { saa.isp_why_box.displayed? }

			wait.until { saa.np_why_link.displayed? }
			js_scroll_up(saa.np_why_link,true)
			saa.np_why_link.click
			wait.until { saa.np_why_box.displayed? }

			$logger.info("Step 2 next step")
			# Click on "Next Step" CTA; we already made sure it's visible
			saa.next_step.click

			test_abandon_modal(3, saa)

			#Make sure date/time are populated; throws an error if we submit form before they are
			wait_longer.until { saa.apt_date_header.displayed? }

			#Click all the active dates/times on the calendar
			$logger.info("Step 3 calander dates/times")
			for r in 1 .. 5
				for c in 1 .. 7
					if saa.calendar_item(r,c).attribute("class").include? "is-active"
						#Click link until it's highlighted or we reach a limit
						start_time = time_now_sec
						while !saa.calendar_item(r,c).attribute("class").include? "ui-datepicker-current-day" do
							js_scroll_up(saa.calendar_item(r,c))
							saa.calendar_item(r,c).click
							if time_now_sec >= start_time + scroll_sleep_time
								fail("Calendar item row: "+ r +" column: "+ c +" did not highlight")
							end
						end
						wait_longer.until { saa.apt_time_header.displayed? }

						#Click all the active times
						saa.times.each do |elem|
							js_scroll_up(elem)
							elem.click
							link = $test_driver.find_element(:link_text, elem.text)
							wait.until { link.displayed? }
							expect(link.attribute("class").include? "is-selected").to eql true
						end
					end
				end
			end

			$logger.info("Step 3 first name")
			#Check invalid input
			#Errors will include "is-error" in class name
			saa.first_name.send_keys("1235")
			#Click another element to fire on-blur
			saa.last_name.click
			#Check for error
			expect(saa.first_name.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.first_name.clear
			saa.first_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "'")
			saa.last_name.click
			expect(saa.first_name.attribute("class").include? "is-error").to eql false

			$logger.info("Step 3 last name")
			#Check invalid input
			saa.last_name.send_keys("12345")
			saa.first_name.click
			expect(saa.last_name.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.last_name.clear
			saa.last_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "-" + ('a'..'z').to_a.shuffle[0,8].join)
			saa.first_name.click
			expect(saa.last_name.attribute("class").include? "is-error").to eql false

			$logger.info("Step 3 email")
			#Check invalid input
			saa.email.send_keys("a@a")
			saa.first_name.click
			expect(saa.email.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.email.clear
			saa.email.send_keys(('a'..'z').to_a.shuffle[0,8].join + "@topnotchltd.com")
			saa.first_name.click
			expect(saa.email.attribute("class").include? "is-error").to eql false

			$logger.info("Step 3 date of birth")
			#Month
			#Check invalid input
			saa.dob_month.send_keys("13")
			saa.first_name.click
			#expect(saa.dob_month.attribute("class").include? "is-error").to eql true
			wait.until { saa.dob_error.displayed? }
			#Check valid input
			saa.dob_month.clear
			saa.dob_month.send_keys(rand(1 .. 12))
			saa.first_name.click
			expect(saa.dob_month.attribute("class").include? "is-error").to eql false

			#Day
			#Check invalid input
			saa.dob_day.send_keys("32")
			saa.first_name.click
			#expect(saa.dob_day.attribute("class").include? "is-error").to eql true
			wait.until { saa.dob_error.displayed? }
			#Check valid input
			saa.dob_day.clear
			saa.dob_day.send_keys(rand(1 .. 31))
			saa.first_name.click
			expect(saa.dob_day.attribute("class").include? "is-error").to eql false

			#Year
			start_year = Date.today.year - 99
			end_year = Date.today.year - 19
			#Check invalid input
			saa.dob_year.send_keys(start_year - 1)
			saa.first_name.click
			#expect(saa.dob_year.attribute("class").include? "is-error").to eql true
			wait.until { saa.dob_error.displayed? }
			saa.dob_year.clear
			saa.dob_year.send_keys(end_year + 2)
			saa.first_name.click
			wait.until { saa.dob_error.displayed? }
			#Check valid input
			saa.dob_year.clear
			saa.dob_year.send_keys(rand(start_year .. end_year))
			saa.first_name.click
			expect(saa.dob_year.attribute("class").include? "is-error").to eql false

			$logger.info("Step 3 phone number")
			#Area code
			#Check invalid input
			saa.pn_area_code.send_keys("abc")
			saa.email.click
			expect(saa.pn_area_code.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.pn_area_code.clear
			saa.pn_area_code.send_keys(rand(200 .. 999))
			saa.email.click
			expect(saa.pn_area_code.attribute("class").include? "is-error").to eql false

			#Exchange code
			#Check invalid input
			saa.pn_exchange_code.send_keys("abc")
			saa.email.click
			expect(saa.pn_exchange_code.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.pn_exchange_code.clear
			saa.pn_exchange_code.send_keys(rand(200 .. 999))
			saa.email.click
			expect(saa.pn_exchange_code.attribute("class").include? "is-error").to eql false

			#Suffix code
			#Check invalid input
			saa.pn_suffix_code.send_keys("abcd")
			saa.email.click
			expect(saa.pn_suffix_code.attribute("class").include? "is-error").to eql true
			#Check valid input
			saa.pn_suffix_code.clear
			saa.pn_suffix_code.send_keys(rand(2000 .. 9999))
			saa.email.click
			expect(saa.pn_suffix_code.attribute("class").include? "is-error").to eql false

			$logger.info("Step 3 Insurance y/n")
			#Make sure we can't continue without selecting one
			wait.until { saa.schedule_cta.displayed? }
			saa.schedule_cta.click
			wait.until { saa.insurance_error.displayed? }
			#Click on 'yes' under "Does the patient have dental insurance?"
			saa.insurance_yes.click
			#Click on 'no' under "Does the patient have dental insurance?"
			saa.insurance_no.click

			$logger.info("Step 3 policy info")
			#Click "Learn about our policy here" link
			saa.policy_link.click
			#Make sure policy message appears
			wait.until { saa.policy_message.displayed? }

			#Select "mobile phone" in the phone type dropdown
			$logger.info("Step 3 Phone Type")
			js_scroll_up(saa.phone_type_dropdown)
			saa.phone_type_dropdown.click
			saa.phone_type_item.click
			#Make sure disclaimer shows
			wait.until { saa.mobile_phone_disclaimer.displayed? }

			$logger.info("Step 3 'why do we ask' link")
			saa.di_why_link.click
			wait.until { saa.di_why_box.displayed? }

			# $logger.info("Step 3 submit form button")
			# #Submit form and check success
			# saa.schedule_cta.click
			# wait_longer.until { saa.thank_you.displayed? }
		end

		# it " - Sign up page" do
		# 	#Get page titles from json
		# 	parsed = JSON.parse(open("spec/page_titles.json").read)
		# 	forsee = ForseePage.new().add_cookies()

		# 	$logger.info("Sign up page")
		# 	#Click SAA link
		# 	header.saa_cta.click
		# 	wait.until { $test_driver.title.include? "Schedule a Dentist Appointment" }

		# 	#Do an adbridged version of the above to get past main SAA screen
		# 	$logger.info("Schedule appointment")
		# 	#Step 1
		# 	#Click yes CTA
		# 	wait.until { saa.yes_cta.displayed? }
		# 	saa.yes_cta.click

		# 	#Step 2
		# 	#Click 'no' under "Has this patient had an exam with us in the past?"
		# 	wait.until { saa.past_exam_no.displayed? }
		# 	saa.past_exam_no.click

		# 	#Click "18 or older" under "How old is the patient?"
		# 	wait.until { saa.how_old_over_18.displayed? }
		# 	saa.how_old_over_18.click

		# 	# Click on "Select primary reason" and choose an item
		# 	wait.until { saa.primary_reason_dropdown.displayed? }
		# 	saa.primary_reason_dropdown.click

		# 	wait.until { saa.primary_reason_item(2).displayed? }
		# 	js_scroll_up(saa.primary_reason_item,true)
		# 	saa.primary_reason_item(2).click

		# 	#Click on "Next Step" CTA
		# 	wait.until { saa.next_step.displayed? }
		# 	saa.next_step.click

		# 	#Step 3
		
		# 	#First name
		# 	wait.until { saa.first_name.displayed? }
		# 	js_scroll_up(saa.first_name)
		# 	saa.first_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "'")
		# 	saa.last_name.click
		# 	expect(saa.first_name.attribute("class").include? "is-error").to eql false

		# 	#Last name
		# 	wait.until { saa.last_name.displayed? }
		# 	saa.last_name.send_keys(('a'..'z').to_a.shuffle[0,8].join + "-" + ('a'..'z').to_a.shuffle[0,8].join)
		# 	saa.first_name.click
		# 	expect(saa.last_name.attribute("class").include? "is-error").to eql false

		# 	#Email
		# 	wait.until { saa.email.displayed? }
		# 	saa.email.send_keys(('a'..'z').to_a.shuffle[0,8].join + "@topnotchltd.com")
		# 	saa.first_name.click
		# 	expect(saa.email.attribute("class").include? "is-error").to eql false

		# 	#DOB
		# 	wait.until { saa.dob_month.displayed? }
		# 	saa.dob_month.send_keys(rand(1 .. 12))
		# 	saa.first_name.click
		# 	expect(saa.dob_month.attribute("class").include? "is-error").to eql false

		# 	#Day
		# 	wait.until { saa.dob_day.displayed? }
		# 	saa.dob_day.send_keys(rand(1 .. 31))
		# 	saa.first_name.click
		# 	expect(saa.dob_day.attribute("class").include? "is-error").to eql false

		# 	#Year
		# 	wait.until { saa.dob_year.displayed? }
		# 	saa.dob_year.send_keys("1975")
		# 	saa.first_name.click
		# 	expect(saa.dob_year.attribute("class").include? "is-error").to eql false

		# 	#Phone number
		# 	#Area code
		# 	wait.until { saa.pn_area_code.displayed? }
		# 	saa.pn_area_code.send_keys(rand(200 .. 999))
		# 	saa.email.click
		# 	expect(saa.pn_area_code.attribute("class").include? "is-error").to eql false

		# 	#Exchange code
		# 	wait.until { saa.pn_exchange_code.displayed? }
		# 	saa.pn_exchange_code.send_keys(rand(200 .. 999))
		# 	saa.email.click
		# 	expect(saa.pn_exchange_code.attribute("class").include? "is-error").to eql false

		# 	#Suffix code
		# 	wait.until { saa.pn_exchange_code.displayed? }
		# 	saa.pn_suffix_code.send_keys(rand(2000 .. 9999))
		# 	saa.email.click
		# 	expect(saa.pn_suffix_code.attribute("class").include? "is-error").to eql false

		# 	#Click on 'yes' under "Does the patient have dental insurance?"
		# 	wait.until { saa.insurance_yes.displayed? }
		# 	saa.insurance_yes.click

		# 	#Wait for calander to propogate
		# 	wait_longer.until { saa.apt_time_header.displayed? }
		# 	#Submit form and check success
		# 	wait.until { saa.schedule_cta.displayed? }
		# 	saa.schedule_cta.click
		# 	wait_longer.until { saa.thank_you.displayed? }

		# 	$logger.info("Sign up")

		# 	$logger.info("Links")
		# 	#Loop through all the links
		# 	links = [saa.print_offers_cta, saa.download_forms_cta, saa.add_calendar_link, saa.directions_link]
		# 	titles = [parsed["top-pages"]["pricing-offers"], parsed["misc"]["patient-forms"], "Calendar", "Google Maps"]
		# 	for i in 0 .. links.length-1
		# 		wait.until { links[i].displayed? }
		# 		links[i].click
		# 		$test_driver.switch_to.window( $test_driver.window_handles.last )
		# 		wait_longer.until { $test_driver.title.include? titles[i] }
		# 		if ENV['BROWSER_TYPE'] == 'IE'
		# 			$test_driver.execute_script("window.open('', '_self', ''); window.close();")
		# 		else
		# 			$test_driver.execute_script("window.close();")
		# 		end
		# 		$test_driver.switch_to.window( $test_driver.window_handles.first )
		# 		#IE likes to not close the window, so double check
		# 		if ENV['BROWSER_TYPE'] == 'IE'
		# 			sleep 3
		# 			if (test_driver.title.include? titles[i])
		# 				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
		# 				$test_driver.switch_to.window( $test_driver.window_handles.first )
		# 			end
		# 		end
		# 	end
		# 	#Check 'add to outlook' link status (we don't want to download the file)
		# 	url = saa.add_outlook_link.attribute("href").split(".com/")
		# 	response = nil
		# 	Net::HTTP.start(url[0].split("https://").last + ".com", 80) {|http|
		# 		response = http.head("/" + url[1])
		# 	}
		# 	if(response.code != "200")
		# 		fail("Outlook link returned code: " + response.code)
		# 	end

		# 	$logger.info("Enter username")
		# 	wait.until { saa.username.displayed? }
		# 	#Invalid input
		# 	invalid_cases = ["12345678","!@#!@#!@","btntes7"]
		# 	for i in 0.. invalid_cases.length-1
		# 		saa.username.clear
		# 		saa.username.send_keys(invalid_cases[i])
		# 		js_scroll_up(saa.password)
		# 		saa.password.click
		# 		expect(saa.username.attribute("class").include? "is-error").to eql true
		# 	end
		# 	#Valid input
		# 	saa.username.clear
		# 	saa.username.send_keys(('a'..'z').to_a.shuffle[0,8].join)
		# 	saa.password.click
		# 	expect(saa.username.attribute("class").include? "is-error").to eql false

		# 	$logger.info("Enter password")
		# 	#Invalid input
		# 	invalid_cases = ["asdfjkl8","asdfjkl#","Bnt$s7"]
		# 	for i in 0.. invalid_cases.length-1
		# 		saa.password.clear
		# 		saa.password.send_keys(invalid_cases[i])
		# 		saa.confirm_password.click
		# 		expect(saa.password.attribute("class").include? "is-error").to eql true
		# 	end
		# 	#Different passwords
		# 	saa.password.clear
		# 	saa.password.send_keys("Bnte$s7")
		# 	saa.confirm_password.clear
		# 	saa.confirm_password.send_keys("Bnte$s8")
		# 	saa.password.click
		# 	expect(saa.confirm_password.attribute("class").include? "is-error").to eql true
		# 	#Valid input
		# 	saa.password.clear
		# 	password = "TN1" + ('a'..'z').to_a.shuffle[0,8].join + "!"
		# 	saa.password.send_keys(password)
		# 	wait.until { saa.confirm_password.displayed? }
		# 	saa.confirm_password.clear
		# 	saa.confirm_password.send_keys(password)
		# 	saa.security_answer.click
		# 	expect(saa.password.attribute("class").include? "is-error").to eql false
		# 	expect(saa.confirm_password.attribute("class").include? "is-error").to eql false

		# 	$logger.info("Security question")
		# 	#Invalid input
		# 	#No input
		# 	saa.security_answer.click
		# 	saa.confirm_password.click
		# 	expect(saa.security_answer.attribute("class").include? "is-error").to eql true
		# 	#Make sure we can't enter more than 50 characters
		# 	over_fifty = "WXka7ZXJB4vKZy4XQ7f8O19HLM6nGPz5SckBGD8Gok0nq5Wy1Q$asdf" #Dollar sign is 51st character
		# 	saa.security_answer.clear
		# 	saa.security_answer.send_keys(over_fifty)
		# 	if(saa.security_answer.attribute("value") != over_fifty.split("$").first)
		# 		fail("Security answer was not truncated to 50 characters")
		# 	end
		# 	#Valid input
		# 	wait.until { saa.security_dropdown.displayed? }
		# 	js_scroll_up(saa.security_dropdown,true)
		# 	saa.security_dropdown.click
		# 	item = rand(1 .. 6)
		# 	wait.until { saa.security_dropdown_item(item).displayed? }
		# 	saa.security_dropdown_item(item).click
		# 	saa.security_answer.send_keys(('a'..'z').to_a.shuffle[0,8].join)
		# 	expect(saa.security_answer.attribute("class").include? "is-error").to eql false

		# 	$logger.info("Checkbox")
		# 	#Make sure CTA changed from being greyed out
		# 	expect(saa.create_cta.attribute("class").include? "inactive").to eql true
		# 	saa.account_checkbox.click
		# 	expect(saa.create_cta.attribute("class").include? "inactive").to eql false

		# 	$logger.info("Create account CTA")
		# 	saa.create_cta.click

		# 	$logger.info("Success page")
		# 	wait_longer.until { saa.account_login_cta.displayed? }
		# 	#Test all the links
		# 	#$test_driver.navigate.to("https://" + $ad_env + $domain + "/my-account?guid=cdf8081eb7e24907bf6fdb2df9565a31&confirmation=1")
		# 	title = "My Account for Upcoming Dental Work"
		# 	scroll = ENV['BROWSER_TYPE'] == 'CHROME'
		# 	test_link_back(saa.sign_in_cta, title, parsed["my-account"]["sign-in"], false, 3, scroll)
		# 	sleep scroll_sleep_time
		# 	test_link_back(saa.browse_cta, title, parsed["top-pages"]["home"], false, 3, scroll)
		# 	sleep scroll_sleep_time
		# 	test_link_back(saa.account_login_cta, title, parsed["my-account"]["sign-in"], false, 3, scroll)
		# 	sleep scroll_sleep_time
		# 	test_link_back(saa.account_faq_link, title, parsed["faqs"]["my-account"], false, 3, scroll)
		# 	sleep scroll_sleep_time
		# 	test_link_back(saa.contact_link, title, parsed["about"]["contact"], false, 3, scroll)
		# end
	end
end