class FaqPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def content()
		return $test_driver.find_element(:id, "content")
	end

	#Get all faq page items
	def items()
		#Compile all three columns into one array
		items = $test_driver.find_element(:class, "index-list").find_elements(:xpath => "//div[@class='grid-whole']/div[@class='grid-third'][1]/ul/li/a")
		items += $test_driver.find_element(:class, "index-list").find_elements(:xpath => "//div[@class='grid-whole']/div[@class='grid-third'][2]/ul/li/a")
		items += $test_driver.find_element(:class, "index-list").find_elements(:xpath => "//div[@class='grid-whole']/div[@class='grid-third'][3]/ul/li/a")
		return items
	end

	def anchor(href)
		return $test_driver.find_element(:id, href.split("#").last)
	end

	#Get all 'back to top' links
	def back_to_top_links()
		return $test_driver.find_elements(:link_text, "Back to top")
	end

	#Landing page
	def call_or_email_link()
		return $test_driver.find_element(:link_text, "Call or email us")
	end

	#My First Visit page
	def new_patient_forms_link()
		return $test_driver.find_element(:link_text, "Download New Patient Forms")
	end

	def download_patient_forms_cta()
		return $test_driver.find_element(:link_text, "Download Patient Forms")
	end

	def treatment_plan_link()
		return $test_driver.find_element(:link_text, "dental treatment plan")
	end

	#Appointments page
	def pricing_and_offers_link()
		return $test_driver.find_element(:link_text, "Pricing & Offers")
	end

	def here_link()
		return $test_driver.find_element(:link_text, "here")
	end

	def please_click_here_link()
		return $test_driver.find_element(:link_text, "please click here")
	end

	#Dental services page
	def here_links() #Note the S
		return $test_driver.find_elements(:link_text, "here")
	end

	#Dentures page
	def ad_dentures_link()
		return $test_driver.find_element(:link_text, "Aspen Dental dentures")
	end

	#My account page
	def my_account_link()
		return $test_driver.find_element(:link_text, "My Account ")
	end

	def login_link()
		return $test_driver.find_element(:link_text, "log-in page")
	end
end