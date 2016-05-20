class MyAccountPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	#Sign in page
	def login_form()
		return $test_driver.find_element(:id, "login-form")
	end

	def username_field()
		return $test_driver.find_element(:id, "username")
	end

	def password_field()
		return $test_driver.find_element(:id, "password")
	end

	def sign_in_cta()
		return $test_driver.find_element(:id, "submit-login")
	end

	def forgot_username_link()
		return $test_driver.find_element(:link_text, "Forgot your username?")
	end

	def forgot_password_link()
		return $test_driver.find_element(:link_text, "Forgot your password?")
	end

	def form_error_msg()
		return $test_driver.find_element(:xpath => "//form[@id='login-form']/span[@class='form-error active']")
	end

	def form_uname_msg()
		return $test_driver.find_element(:xpath => "//form[@id='login-form']/fieldset[@class='grid-whole field-container']/div[@class='input-container']/div[@class='input-wrapper'][1]/span[@class='form-error active']")
	end

	def forgot_username_link()
		return $test_driver.find_element(:link_text, "Forgot your username?")
	end

	def forgot_password_link()
		return $test_driver.find_element(:link_text, "Forgot your password?")
	end

	def no_account_container()
		return $test_driver.find_element(:xpath => "//div[@class='grid-half'][2]/div[@class='login-column']")
	end

	def sign_up_cta()
		return $test_driver.find_element(:link_text, "Sign Up for My Account")
	end

	#Perform login
	def perform_login(username, password)
		header = HeaderPage.new()
		wait = Selenium::WebDriver::Wait.new(timeout: 3)
		wait_long = Selenium::WebDriver::Wait.new(timeout: 7)
		test_val = TestValidation.new()

		header.my_account_cta.click
		wait.until { $test_driver.current_url.include? "/my-account/login" }
		
		num_retry = 0
		begin
			test_val.text_input(username_field, username, false)
			test_val.text_input(password_field, password, false)
			login_form.submit
			wait_long.until { make_a_payment_link.displayed? }
		rescue Selenium::WebDriver::Error::TimeOutError
			#Try again (thanks chrome)
			sleep 1
			retry if (num_retry += 1) == 1
			fail("Failed to login as user: " + username + " Pass: " + password)
		end
	end

	#Forgot username (fu) modal
	def fu_container()
		return $test_driver.find_element(:id, "forgot-username-container")
	end

	def fu_fname_field()
		return $test_driver.find_element(:id, "first_name")
	end

	def fu_lname_field()
		return $test_driver.find_element(:id, "last_name")
	end

	def fu_account_no_field()
		return $test_driver.find_element(:id, "account_number")
	end

	def fu_submit_cta()
		return $test_driver.find_element(:id, "forgot-modal--submit-button")
	end

	def fu_message()
		return $test_driver.find_element(:xpath => "//div[@id='forgot-username-container']/p[@class='forgot-password-message']")
	end

	def fu_close_cta()
		return $test_driver.find_element(:xpath => "//div[@class='modal-content forgot-username-modal modal-global']/span[@class='icon icon-cancel-circle modal-close']")
	end

	#Forgot password (fp) modal
	def fp_container()
		return $test_driver.find_element(:id, "forgot-password-container")
	end

	#Will be username and security fields; check attributes
	def fp_text_field()
		return $test_driver.find_element(:id, "forgot-submit")
	end

	def fp_submit_cta()
		return $test_driver.find_element(:id, "forgot-modal--submit-button")
	end

	def fp_message()
		return $test_driver.find_element(:xpath => "//div[@id='forgot-password-container']/p[@class='forgot-password-message']")
	end

	def fp_reset_message()
		return $test_driver.find_element(:xpath => "//div[@id='forgot-password-container']/div[@class='message message-password-reset']/p")
	end

	def fp_close_cta()
		return $test_driver.find_element(:xpath => "//div[@class='modal-content forgot-password-modal modal-global']/span[@class='icon icon-cancel-circle modal-close']")
	end

	def fp_error_msg()
		return $test_driver.find_element(:xpath => "//form[@id='change-password-form']/fieldset[@class='field-container has-error']/span[@class='form-error active']")
	end

	def fp_password_field()
		return $test_driver.find_element(:id, "create_password")
	end

	def fp_confirm_pass_field()
		return $test_driver.find_element(:id, "confirm_password")
	end

	def fp_pass_submit_cta()
		return $test_driver.find_element(:xpath => "//div[@id='forgot-password-container']/form[@id='change-password-form']/input[@class='button submit-forgot-password']")
	end

	#My Account page (logged in)
	def sign_out_link()
		return $test_driver.find_element(:xpath => "//div[@id='account-info']/div[@class='contact-info-wrapper grid-third']/p[@class='account-title']/a[@class='logout']")
	end

	def holder_info()
		return $test_driver.find_element(:class, "account-holder")
	end

	def welcome_text()
		return $test_driver.find_element(:xpath => "//div[@id='account-info']/div[@class='contact-info-wrapper grid-third']/p[@class='account-title']")
	end

	def office_details()
		return $test_driver.find_element(:xpath => "//div[@id='account-info']/div[@class='contact-info-wrapper grid-third']/p[@class='office-details']")
	end

	def empty_notification()
		return $test_driver.find_element(:xpath => "//div[@id='account-info']/div[@class='welcome-patient-wrapper grid-two-thirds']/div[@class='appointments-box']/div[@class='notification empty']")
	end

	def account_balance()
		return $test_driver.find_element(:xpath => "//div[@class='balance-cta']/div[@class='grid-half'][1]/h1")
	end

	#Appointment messaging section
	def apt_next()
		return $test_driver.find_element(:class, "next-appointment")
	end

	def apt_prev()
		return $test_driver.find_element(:class, "previous-appointment")
	end

	def apt_slide(i)
		return $test_driver.find_element(:xpath => "//div[@class='slick-track']/div["+i.to_s+"]")
	end

	def apt_wrappers()
		return $test_driver.find_elements(:xpath => "//div[@class='slick-track']/div/div[@class='appointment-wrapper']")
	end

	def apt_slide_dates()
		return $test_driver.find_elements(:class, "schedule-date")
	end

	def man_apt_link()
		return $test_driver.find_element(:link_text, "MANAGE ALL APPOINTMENTS")
	end

	#My Account links
	def my_account_sidebar_link()
		return $test_driver.find_element(:xpath => "//div[@id='sidebar']/h3/a")
	end

	def my_account_statements_link()
		return $test_driver.find_element(:xpath => "//li[@id='statements']/a")
	end
	
	def manage_appointments_link()
		return $test_driver.find_element(:partial_link_text, "Manage Appointments")
	end

	def update_password_link()
		return $test_driver.find_element(:partial_link_text, "Update Password")
	end

	def make_a_payment_link()
		return $test_driver.find_element(:partial_link_text, "Make a Payment")
	end

	#Account information links
	def account_info_statements()
		return $test_driver.find_element(:xpath => "//div[@class='content']/div[@class='grid-whole'][1]/div[@class='grid-4'][1]/div[@class='section-block statements-info']/a[@class='title']")
	end

	def current_statement()
		return $test_driver.find_element(:class, "pdf_image")
	end

	#Tools and resources links
	def tools_manage_appointments()
		return $test_driver.find_element(:xpath => "//div[@class='content']/div[@class='grid-whole'][1]/div[@class='grid-4'][2]/div[@class='section-block']/a[@class='title']")
	end

	#My account profile links
	def profile_update_password_link()
		return $test_driver.find_element(:xpath => "//div[@class='content']/div[@class='grid-whole'][1]/div[@class='grid-4 middle-grid']/div[@class='section-block']/a[@class='title pencil']")
	end

	#Manage appointments page
	def no_appointments()
		return $test_driver.find_element(:xpath => "//div[@id='manage-appointments']/div[@class='main']/div[@class='grid-8']/div[@class='content']/div/p")
	end

	def no_of_apt()
		return $test_driver.find_element(:class, "total-app-count")
	end

	def apt_data_containers()
		return $test_driver.find_elements(:class, "appointment-data")
	end

	#Make a payment modal
	def map_modal()
		return $test_driver.find_element(:xpath => "//div[@class='modal-content grid-two-thirds modal make-payment-modal  modal-global']")
	end

	def map_modal_x()
		return $test_driver.find_element(:xpath => "//span[@class='icon icon-cancel-circle modal-close']")
	end

	def map_account_balance_check()
		return $test_driver.find_element(:xpath => "//form[@id='account-payment']/div[@class='payment-amount input-wrapper field-container']/div[@class='input-container grid-whole']/fieldset[1]/label")
	end

	def map_other_amount_check()
		return $test_driver.find_element(:xpath => "//form[@id='account-payment']/div[@class='payment-amount input-wrapper field-container']/div[@class='input-container grid-whole']/fieldset[2]/label")
	end

	def map_other_amount_field()
		return $test_driver.find_element(:id, "input-alternate-amount")
	end

	def map_billing_info()
		return $test_driver.find_element(:id, "billing-info")
	end

	def map_edit_link()
		return $test_driver.find_element(:id, "change-address-modal")
	end

	def map_street_address()
		return $test_driver.find_element(:xpath => "//input[@name='street']")
	end

	def map_city()
		return $test_driver.find_element(:xpath => "//input[@name='city']")
	end

	def map_state()
		return $test_driver.find_element(:xpath => "//input[@name='state']")
	end

	def map_zip()
		return $test_driver.find_element(:xpath => "//input[@name='state']")
	end

	def map_cancel_address_cta()
		return $test_driver.find_element(:id, "cancel-change")
	end

	def map_update_address_cta()
		return $test_driver.find_element(:id, "update-address")
	end

	#Credit card stuff
	def map_cc_type()
		return $test_driver.find_element(:id, "dk0-combobox")
	end

	def map_cc_type_item(cc_name)
		return $test_driver.find_element(:id, "dk0-" + cc_name)
	end

	def map_cc_picture(i)
		return $test_driver.find_element(:xpath => "//div[@class='card-type-wrapper card-container']/ul[@class='payment-methods']/li["+i.to_s+"]")
	end

	def map_cc_no()
		return $test_driver.find_element(:id, "card-number")
	end

	def map_cc_month()
		return $test_driver.find_element(:id, "dk_container_card-month")
	end

	def map_cc_year()
		return $test_driver.find_element(:id, "dk_container_card-year")
	end

	def map_cc_cvv()
		return $test_driver.find_element(:class, "security-code")
	end

	def map_cc_date_error()
		return $test_driver.find_element(:xpath => "//div[@class='partial-content-box payment-data']/fieldset[@class='expiration-wrapper']/span[@class='form-error active']")
	end

	def map_cc_month()
		return $test_driver.find_element(:id, "dk1-combobox")
	end

	def map_cc_month_item(i) #Must include trailing zero; therefor it should be a string
		return $test_driver.find_element(:id, "dk1-" + i)
	end

	def map_cc_year()
		return $test_driver.find_element(:id, "dk2-combobox")
	end

	def map_cc_year_item(i) # i = year (e.g. 2017)
		return $test_driver.find_element(:id, "dk2-" + i.to_s)
	end

	def map_cancel_cta()
		return $test_driver.find_element(:id, "cancel-payment")
	end

	def map_submit_cta()
		return $test_driver.find_element(:id, "submit-payment")
	end

	#Update password page
	def pass_old()
		return $test_driver.find_element(:id, "forgot-password-old")
	end

	def pass_new()
		return $test_driver.find_element(:id, "forgot-password-new")
	end

	def pass_confirm()
		return $test_driver.find_element(:id, "forgot-password-confirm")
	end

	def pass_form_error()
		return $test_driver.find_element(:xpath => "//form[@id='change-password-form']/fieldset[@class='field-container grid-whole has-error']/span[@class='form-error active']")
	end

	def pass_submit_cta()
		return $test_driver.find_element(:id, "submit-change-password")
	end

	#Statements page
	def statements()
		return $test_driver.find_elements(:xpath => "//div[@class='content']/div[@class='grid-whole appointment-list']/div[@class='mobile_list']/div[@class='grid-4']/a/p")
	end

	def here_link()
		return $test_driver.find_element(:xpath => "//div[@class='content']/div[@class='has-statements']/p[@class='current-message']/a")
	end

	#Manage appointments page
	def ma_phone_number()
		return $test_driver.find_element(:xpath => "//strong[@class='near-office-phone']/span[@class='telephone']")
	end

	def reschedule_cta()
		return $test_driver.find_element(:partial_link_text, "Reschedule")
	end

	def reschedule_ctas()
		return $test_driver.find_elements(:partial_link_text, "Reschedule")
	end

	def reschedule_modal()
		return $test_driver.find_element(:id, "reschedule-appointment")
	end

	def reschedule_header()
		return $test_driver.find_element(:xpath => "//form[@id='reschedule-appointment']/h3[@class='bar']")
	end

	def reschedule_x()
		return $test_driver.find_element(:xpath => "//span[@class='icon icon-cancel-circle modal-cancel-close']")
	end

	def reschedule_apt_name()
		return $test_driver.find_element(:class, "appointment-name")
	end

	def reschedule_apt_patient_info()
		return $test_driver.find_element(:class, "patient-info")
	end

	def reschedule_office_details()
		return $test_driver.find_element(:xpath => "//div[@class='content-box upcoming-info']/div[@class='patient-info grid-whole']/div[@class='grid-half'][2]/dl[1]/dt[1]")
	end

	def reschedule_office_links()
		return $test_driver.find_elements(:class, "appointment-detail-title")
	end

	def reschedule_day_header() #Used to check if dates are populated
		return $test_driver.find_element(:class, "ui-datepicker-month")
	end

	def reschedule_days(row, column)
		return $test_driver.find_element(:xpath => "//table[@class='ui-datepicker-calendar']/tbody/tr["+row.to_s+"]/td["+column.to_s+"]/a")
	end

	def reschedule_time_header() #Also used to check population
		return $test_driver.find_element(:class, "appointment-date-time")
	end

	def reschedule_times(row, column)
		return $test_driver.find_element(:xpath => "//div[@id='appointment-time']/div[@class='grid-half']["+column.to_s+"]/ol/li["+row.to_s+"]/a")
	end

	def reschedule_submit_cta()
		return $test_driver.find_element(:class, "save-link")
	end

	#Success modal
	def confirm_message()
		return $test_driver.find_element(:class, "confirm-message")
	end

	def confirm_subtitle()
		return $test_driver.find_element(:class, "confirm-subtitle")
	end

	def reschedule_apt_time()
		return $test_driver.find_element(:class, "schedule-time")
	end

	def reschedule_office_details()
		return $test_driver.find_element(:xpath => "//div[@class='upcoming-info']/div[@class='patient-info grid-whole']/div[@class='grid-half'][2]/dl[1]/dt[@class='blue']")
	end

	def reschedule_google_cal_link()
		return $test_driver.find_element(:partial_link_text, "Add to Google Calendar")
	end

	def reschedule_google_map_link()
		return $test_driver.find_element(:partial_link_text, "Get Directions")
	end

	def reschedule_close_cta()
		return $test_driver.find_element(:class, "confirm-close")
	end

	#Cancel appointment
	def cancel_links()
		return $test_driver.find_elements(:class, "cancel-link")
	end

	def cancel_modal()
		return $test_driver.find_element(:id, "cancel-appointment")
	end

	def cancel_modal_x()
		return $test_driver.find_element(:xpath => "//span[@class='icon icon-cancel-circle modal-close']")
	end

	def cancel_modal_header()
		return $test_driver.find_element(:xpath => "//form[@id='cancel-appointment']/h3")
	end

	def cancel_copy()
		return $test_driver.find_element(:xpath => "//div[@class='content-box upcoming-info cancel-modal']")
	end

	def cancel_apt_details()
		return $test_driver.find_element(:xpath => "//div[@class='content-box upcoming-info cancel-modal']/h4")
	end

	def cancel_apt_time()
		return $test_driver.find_element(:class, "schedule-time")
	end

	def cancel_office_details()
		return $test_driver.find_element(:xpath => "//div[@class='content-box upcoming-info cancel-modal']/div[@class='patient-info grid-whole']/div[@class='grid-half'][2]")
	end

	def cancel_yes_copy()
		return $test_driver.find_element(:class, "drop-down-title")
	end

	def cancel_close_link()
		return $test_driver.find_element(:class, "close-link")
	end

	def cancel_reason_question()
		return $test_driver.find_element(:class, "reason-question")
	end

	def cancel_required_message()
		return $test_driver.find_element(:class, "required-message")
	end

	def cancel_reschedule_cta()
		return $test_driver.find_element(:xpath => "//form[@id='cancel-appointment']/div[@class='content-box upcoming-info cancel-modal']/div[2]/button[@class='button cancel-reschedule reschedule-link']")
	end

	def cancel_reason_dropdown()
		return $test_driver.find_element(:id, "dk0-combobox")
	end

	#Letter must be capital, A - F
	def cancel_reason_dropdown_items(letter)
		return $test_driver.find_element(:id, "dk0-" + letter)
	end

	def cancel_submit()
		return $test_driver.find_element(:class, "save-link")
	end
end