class EpsilonPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
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

	def confirm_email()
		return $test_driver.find_element(:id, "confirm-email")
	end

	def zip_code()
		return $test_driver.find_element(:id, "zip-code")
	end

	def select_month()
		return $test_driver.find_element(:class, "dk_toggle")
	end

	def month_option()
		return $test_driver.find_element(:id, "dk_container_date").find_element(:xpath => "//div[@class='dk_options']/ul[@class='dk_options_inner']/li[12]/a")
	end

	def month_error()
		return $test_driver.find_element(:id, "schedule-signup-form").find_element(:xpath => "//div/div[@class='grid-whole padded-button']/p[@id='errorDisplay']")
	end

	def gender()
		return $test_driver.find_element(:id, "gender")
	end

	def submit_cta()
		return $test_driver.find_element(:link_text, "Submit")
	end

	def thank_you()
		return $test_driver.find_element(:id, "content").find_element(:xpath => "//div[@class='container direct-container']/div[@class='schedule-signup']/div[@class='box-content grid-whole thank']")
	end
end