class SaaPage

	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	#Abandonment stuff
	def logo_link()
		return $test_driver.find_element(:partial_link_text, 'Your mouth. Our mission.')
	end

	def back_to_home_link()
		return $test_driver.find_element(:link_text, "Back to Home Page")
	end

	#Footer links
	def privacy_policy_link()
		return $test_driver.find_element(:link_text, "Privacy Policy")
	end

	def terms_of_use_link()
		return $test_driver.find_element(:link_text, "Terms of Use")
	end

	def site_map_link()
		return $test_driver.find_element(:partial_link_text, "Site Map")
	end

	def office_listings_link()
		return $test_driver.find_element(:link_text, "Dental Office Listings")
	end

	def abandonment_modal()
		return $test_driver.find_element(:class, "modal-close")
	end

	#This is the circular X cta
	def close_abandon_modal()
		return $test_driver.find_element(:partial_link_text, "Back to scheduling my appointment")
	end

	def remind_me_later()
		return $test_driver.find_element(:partial_link_text, "Remind me later")
	end

	def yes_leave_link()
		return $test_driver.find_element(:partial_link_text, "Yes, I'd like to leave")
	end

	def back_to_schedule_cta()
		return $test_driver.find_element(:partial_link_text, "Back to scheduling my appointment")
	end

  	def yes_cta()
  		return $test_driver.find_element(:partial_link_text, 'Yes')
	end

	#Step 1

	def show_location()
		return $test_driver.find_element(:id, "show-location")
	end

	def location_name()
		return $test_driver.find_element(:class, "location-name")
	end

	def fao_link()
		return $test_driver.find_element(:link_text, "No? Choose another one of our 500 locations.")
	end

	# np = new-patient
	def np_why_link()
		return $test_driver.find_elements(:class, "whylink")[0]
	end

	#isp = is-new-patient
	def isp_why_link()
		return $test_driver.find_elements(:class, "whylink")[1]
	end

	#iae = is-above-eighteen
	def iae_why_link()
		return $test_driver.find_elements(:class, "whylink")[2]
	end

	def np_why_box()
		return $test_driver.find_element(:id, "new-patient-container").find_element(:xpath => "//div[@class='whydoweask']/div[@class='whybox active']")
	end

	def isp_why_box()
		return $test_driver.find_element(:id, "new-patient-container").find_element(:xpath => "//div[@class='is-new-patient']/div[@class='whydoweask']/div[@class='whybox active']")
	end

	def iae_why_box()
		return $test_driver.find_element(:id, "new-patient-container").find_element(:xpath => "//div[@class='is-above-eighteen']/div[@class='whydoweask']/div[@class='whybox active']")
	end


	def past_exam_yes()
		#The 'no' checkbox has the id of new_patient_no for some reason
		return $test_driver.find_element(:class, "new-patient-form").find_element(:xpath => "//fieldset/div[1]/label")
	end

	def past_exam_no()
		#The 'no' checkbox has the id of new_patient_yes for some reason
		return $test_driver.find_element(:class, "new-patient-form").find_element(:xpath => "//fieldset/div[2]/label")
	end

	def past_exam_disclaimer()
		return $test_driver.find_element(:id, "new-patient-container").find_element(:xpath => "//div[@class='saa-message returning-patient-gate is-returning-patient']/p")
	end


	def how_old_under_18()
		return $test_driver.find_element(:class, "is-new-patient").find_element(:xpath => "//form[@class='age-verification-form']/fieldset/div[1]/label")
	end

	def how_old_over_18()
		return $test_driver.find_element(:class, "is-new-patient").find_element(:xpath => "//form[@class='age-verification-form']/fieldset/div[2]/label")
	end

	def age_disclaimer()
		return $test_driver.find_element(:id, "new-patient-container").find_element(:xpath => "//div[@class='is-new-patient']/div[@class='saa-message schedule-age-disclaimer']/p")
	end


	def primary_reason_dropdown()
		return $test_driver.find_element(:id, "dk0-combobox")
	end

	def primary_reason_item(number = nil)
		if number == nil
			number = rand(2..7)
		end
		return $test_driver.find_element(:xpath => "//ul[@id='dk0-listbox']/li["+number.to_s+"]")
	end

	def reason_error()
		return $test_driver.find_element(:class, "reason-error")
	end

	def next_step()
		return $test_driver.find_element(:partial_link_text, "Next Step")
	end

	#Check existance to make sure dates/times are loaded
	def apt_date_header()
		return $test_driver.find_element(:class, "ui-datepicker-title")
	end
	def apt_time_header()
		return $test_driver.find_element(:id, "make-appointment").find_element(:xpath => "//div[@class='tab-content']/div[@class='grid-whole appointment-date-wrapper']/div[@id='appointment-time']/h4")
	end

	def calendar_item(row, column)
		return $test_driver.find_element(:class, "ui-datepicker-calendar").find_element(:xpath => "//tbody/tr[" + row.to_s + "]/td[" + column.to_s + "]")
	end

	#Find ALL the AM/PM times since they can have wildy varying numbers, as opposed the dates
	def times()
		times = $test_driver.find_element(:id, "appointment-time").find_elements(:xpath => "//div[@class='grid-half'][1]/ol/li/a")
		times += $test_driver.find_element(:id, "appointment-time").find_elements(:xpath => "//div[@class='grid-half'][2]/ol/li/a")
		return times
	end

	def first_name()
		return $test_driver.find_element(:id, "first-name")
	end

	def last_name()
		return $test_driver.find_element(:id, "last-name")
	end

	def email()
		return $test_driver.find_element(:id, "email")
	end

	def dob_month()
		return $test_driver.find_element(:id, "month")
	end

	def dob_day()
		return $test_driver.find_element(:id, "day")
	end

	def dob_year()
		return $test_driver.find_element(:id, "year")
	end

	def dob_error()
		return $test_driver.find_element(:xpath => "//div[@id='dob-inputs']/span[@class='form-error active']")
	end

	#pn = phone number
	def pn_area_code()
		return $test_driver.find_element(:id, "area-code")
	end

	def pn_exchange_code()
		return $test_driver.find_element(:id, "exchange-code")
	end

	def pn_suffix_code()
		return $test_driver.find_element(:id, "suffix-code")
	end

	def phone_type_dropdown()
		return $test_driver.find_element(:id, "dk1-phoneTypeSelect")
	end

	def phone_type_item()
		return $test_driver.find_element(:id, "dk1-2")
	end

	def mobile_phone_disclaimer()
		return $test_driver.find_element(:class, "mobile-legal")
	end

	def insurance_yes()
		return $test_driver.find_element(:id, "new-patient-form").find_element(:xpath => "//div[@class='grid-whole no-title']/div[contains(@class,'grid-whole field-container')]/fieldset[@class='grid-whole']/div[@class='padded dental-insurance']/label[1]/span")
	end

	def insurance_no()
		return $test_driver.find_element(:id, "new-patient-form").find_element(:xpath => "//div[@class='grid-whole no-title']/div[contains(@class,'grid-whole field-container')]/fieldset[@class='grid-whole']/div[@class='padded dental-insurance']/label[2]/span")
	end

	def insurance_error()
		return $test_driver.find_element(:id, "new-patient-form").find_element(:xpath => "//div[@class='grid-whole no-title']/div[@class='grid-whole field-container has-error']/div[@class='grid-half'][1]/span")
	end

	def policy_link()
		return $test_driver.find_element(:link_text, "here")
	end

	def policy_message()
		return $test_driver.find_element(:id, "policy-message")
	end

	#di = dental insurance
	def di_why_link()
		return $test_driver.find_element(:id, "new-patient-form").find_element(:xpath => "//div[@class='grid-whole no-title']/div[@class='grid-whole field-container']/div[@class='grid-half'][2]/div[@class='whydoweask']/a[@class='whylink']")
	end

	def di_why_box()
		return $test_driver.find_element(:id, "new-patient-form").find_element(:xpath => "//div[@class='grid-whole no-title']/div[@class='grid-whole field-container']/div[@class='grid-half'][2]/div[@class='whydoweask']/div[@class='whybox active']")
	end

	def schedule_cta()
		return $test_driver.find_element(:id, "submit-form-button")
	end

	#Thank you page
	def print_offers_cta()
		return $test_driver.find_element(:link_text, "Print Your Offers")
	end

	def download_forms_cta()
		return $test_driver.find_element(:link_text, "Download New Patient Forms")
	end

	def add_outlook_link()
		return $test_driver.find_element(:link_text, "Add To Outlook")
	end

	def add_calendar_link()
		return $test_driver.find_element(:link_text, "Add To Calendar")
	end

	def directions_link()
		return $test_driver.find_element(:link_text, "Get Directions")
	end
	
	def thank_you()
		#Check if form went through
		return $test_driver.find_element(:id, "thank-you")
	end

	def form_error()
		return $test_driver.find_element(:xpath => "//span[@class='form-error active grid-7']")
	end

	def username()
		return $test_driver.find_element(:id, "form-create-username")
	end

	def password()
		return $test_driver.find_element(:id, "form-create-password")
	end

	def confirm_password()
		return $test_driver.find_element(:id, "form-confirm-password")
	end

	def security_dropdown()
		return $test_driver.find_element(:id, "dk2-combobox")
	end

	def security_dropdown_item(i)
		return $test_driver.find_element(:id, "dk2-" + i.to_s)
	end

	def security_answer()
		return $test_driver.find_element(:id, "form-security-answer")
	end

	def account_checkbox()
		return $test_driver.find_element(:id, "create-account-form").find_element(:xpath => "//fieldset[@class='legal-wrapper field-container']/div[@class='input-container grid-whole checkbox-container']/label[@class='agree-label input-label']")
	end

	def create_cta()
		return $test_driver.find_element(:id,"submit-create-account")
	end

	#Account success page
	def sign_in_cta()
		return $test_driver.find_element(:id,"sign-up-bar").find_element(:xpath => "//div[@class='grid-whole']/div[@class='grid-half'][2]/div[@class='loginbox']/a[@class='button']")
	end

	def browse_cta()
		return $test_driver.find_element(:id,"sign-up").find_element(:xpath => "//div[@class='cta-wrapper grid-two-thirds']/a[@class='button']")
	end

	def account_login_cta()
		return $test_driver.find_element(:id,"new-account-login")
	end

	def account_faq_link()
		return $test_driver.find_element(:id, "sign-up").find_element(:xpath => "//div[@class='help-wrapper grid-two-thirds']/p[@class='help-message-wrapper']/span[@class='help-message'][2]/a[1]")
	end

	def contact_link()
		return $test_driver.find_element(:id, "sign-up").find_element(:xpath => "//div[@class='help-wrapper grid-two-thirds']/p[@class='help-message-wrapper']/span[@class='help-message'][2]/a[2]")
	end
end