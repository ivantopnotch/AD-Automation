class DentalServicesPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def content()
		return $test_driver.find_element(:id, "content")
	end

	#Landing page
	def emergency_cta()
		return $test_driver.find_element(:partial_link_text, "Have an emergency?")
	end

	#Emergency dental care
	def phone_number()
		return $test_driver.find_element(:class, "telephone")
	end

	#Checkups page
	def oral_health_link()
		return $test_driver.find_element(:link_text, "oral health")
	end

	def click_here_link()
		return $test_driver.find_element(:link_text, "click here")
	end

	def learn_more_cta()
		return $test_driver.find_element(:partial_link_text, "Learn more about your first dental visit")
	end

	#Tooth extraction page
	def overcoming_anxiety_link()
		return $test_driver.find_element(:link_text, "overcoming dental anxiety")
	end

	#Root canal cost page
	def gum_disease_link()
		return $test_driver.find_element(:link_text, "gum disease")
	end

	#Dental crowns page
	def other_systems_link()
		return $test_driver.find_element(:partial_link_text, "other systems")
	end

	#Oral surgery page
	def oral_surgery_links()
		return $test_driver.find_element(:id, "dental-services").find_elements(:xpath => "//div[@class='main']/div[@class='grid-8']/div[@class='content']/div[1]/ul/li/a")
	end

	#Dental implants page
	def contact_link()
		return $test_driver.find_element(:link_text, "Contact")
	end

	#Dental implant cost page
	def implant_link()
		#Does not interfere with sidebar link because of lowercase
		return $test_driver.find_element(:link_text, "dental implants")
	end

	#Cosmetic dentistry page
	def teeth_whitening_link()
		return $test_driver.find_element(:link_text, "teeth whitening")
	end

	def veneers_link()
		return $test_driver.find_element(:link_text, "veneers")
	end
end