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
		return $test_driver.find_element(:xpath => "//span[@class='form-error active']")
	end

	def forgot_username_link()
		return $test_driver.find_element(:link_text, "Forgot your username?")
	end

	def forgot_password_link()
		return $test_driver.find_element(:link_text, "Forgot your password?")
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

	def make_a_payment_link()
		return $test_driver.find_element(:partial_link_text, "Make a Payment")
	end
end