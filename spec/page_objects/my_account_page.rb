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

end