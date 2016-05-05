class ForseePage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	#Wait for forsee modal to appear, and then close it
	def wait_close_modal(timeout = 15)
		if ENV['BROWSER_TYPE'] != "FIREFOX"
			return
		end
		
		begin
			Selenium::WebDriver::Wait.new(timeout: timeout).until { overlay.displayed? }
			no_thanks.click
		#Don't error out if it never appears
		rescue Selenium::WebDriver::Error::TimeOutError
			return
		end
	end

	#Add forsee cookies, to stop it from appearing
	#Do not do this if you need to test forsee functionality
	def add_cookies()
		$test_driver.manage.add_cookie(name: "fsr.r", value: "%7B%22d%22%3A90%2C%22i%22%3A%22d464cf6-84193530-aa4b-f693-7660a%22%2C%22e%22%3A1457108097577%7D")
		$test_driver.manage.add_cookie(name: "fsr.s", value: "%7B%22v2%22%3A1%2C%22v1%22%3A1%2C%22rid%22%3A%22d464cf6-84193530-aa4b-f693-7660a%22%2C%22ru%22%3A%22https%3A%2F%2Fbravo-www.aspendental.com%2F%22%2C%22r%22%3A%22bravo-www.aspendental.com%22%2C%22st%22%3A%22%22%2C%22cp%22%3A%7B%22Scheduled_Appointment%22%3A%22N%22%2C%22Downloaded_Coupon%22%3A%22N%22%7D%2C%22to%22%3A4%2C%22c%22%3A%22https%3A%2F%2Fbravo-www.aspendental.com%2F%22%2C%22pv%22%3A9%2C%22lc%22%3A%7B%22d1%22%3A%7B%22v%22%3A9%2C%22s%22%3Atrue%2C%22e%22%3A1%7D%7D%2C%22cd%22%3A1%2C%22sd%22%3A1%2C%22mid%22%3A%22d464cf6-84193983-febb-036c-85099%22%2C%22rt%22%3Afalse%2C%22rc%22%3Atrue%2C%22f%22%3A1456505141058%2C%22l%22%3A%22en%22%2C%22i%22%3A0%7D")

		$test_driver.execute_script("document.cookie = 'fsr.r = %7B%22d%22%3A90%2C%22i%22%3A%22d464cf6-84193530-aa4b-f693-7660a%22%2C%22e%22%3A1457108097577%7D'")
		$test_driver.execute_script("document.cookie = 'fsr.s = %7B%22v2%22%3A1%2C%22v1%22%3A1%2C%22rid%22%3A%22d464cf6-84193530-aa4b-f693-7660a%22%2C%22ru%22%3A%22https%3A%2F%2Fbravo-www.aspendental.com%2F%22%2C%22r%22%3A%22bravo-www.aspendental.com%22%2C%22st%22%3A%22%22%2C%22cp%22%3A%7B%22Scheduled_Appointment%22%3A%22N%22%2C%22Downloaded_Coupon%22%3A%22N%22%7D%2C%22to%22%3A4%2C%22c%22%3A%22https%3A%2F%2Fbravo-www.aspendental.com%2F%22%2C%22pv%22%3A9%2C%22lc%22%3A%7B%22d1%22%3A%7B%22v%22%3A9%2C%22s%22%3Atrue%2C%22e%22%3A1%7D%7D%2C%22cd%22%3A1%2C%22sd%22%3A1%2C%22mid%22%3A%22d464cf6-84193983-febb-036c-85099%22%2C%22rt%22%3Afalse%2C%22rc%22%3Atrue%2C%22f%22%3A1456505141058%2C%22l%22%3A%22en%22%2C%22i%22%3A0%7D'")
	end

	def overlay()
		return $test_driver.find_element(:id, "fsrOverlay")
	end

	def no_thanks()
		return $test_driver.find_element(:link_text, "No, thanks")
	end
end