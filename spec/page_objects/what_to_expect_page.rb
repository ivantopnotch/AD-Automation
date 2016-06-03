class WhatToExpectPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end
	
	#Landing page
	def call_us_link()
		return $test_driver.find_element(:link_text, "call us")
	end

	#Peace of mind promise page
	def local_practice_link()
		return $test_driver.find_element(:link_text, "local Aspen Dental practice")
	end

	#First dental visit page
	def call_links()
		return $test_driver.find_elements(:link_text, "call")
	end

	def write_link()
		return $test_driver.find_element(:link_text, "write")
	end

	def new_paperwork_link()
		return $test_driver.find_element(:link_text, "new patient paperwork now")
	end

	def dental_plan_link()
		return $test_driver.find_element(:link_text, "dental treatment plan")
	end

	def oral_health_link()
		return $test_driver.find_element(:link_text, "oral health")
	end

	def pomp_link()
		return $test_driver.find_element(:link_text, "Peace of Mind Promise®")
	end

	def schedule_link()
		return $test_driver.find_element(:link_text, "Schedule")
	end

	#Emergency treatment page
	def search_link()
		return $test_driver.find_element(:link_text, "Search")
	end

	#On-going care appointment page
	def periodontal_disease_link()
		return $test_driver.find_element(:link_text, "periodontal disease")
	end

	#Understanding dental treatment plan page
	def dental_services_link()
		return $test_driver.find_element(:link_text, "dental services")
	end

	def pom_link()
		return $test_driver.find_element(:link_text, "Peace of mind")
	end

	#Getting dentures page
	def your_ad_practice_link()
		return $test_driver.find_element(:link_text, "your Aspen Dental practice")
	end

	def reline_link()
		return $test_driver.find_element(:link_text, "reline")
	end

	def call_ahead_link()
		return $test_driver.find_element(:link_text, "call ahead")
	end

	def rebased_link()
		return $test_driver.find_element(:link_text, "rebased")
	end

	def overall_health_link()
		return $test_driver.find_element(:link_text, "overall health")
	end

	def view_details_cta()
		return $test_driver.find_element(:partial_link_text, "View details")
	end
end