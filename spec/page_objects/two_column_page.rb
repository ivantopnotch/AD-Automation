class TwoColumnPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def content()
		return $test_driver.find_element(:id, "content")
	end

	def billboard()
		#return $test_driver.find_element(:id, "content").find_element(:xpath => "//div[@class='wrapper wrapper-banner-subpages']/div[@class='grid-whole banner-subpages']/div")
		return $test_driver.find_element(:class, "banner-subpages-content")
	end

	#Get all breadcrumbs
	def breadcrumbs()
		return $test_driver.find_element(:id, "content").find_elements(:xpath => "//div[@class='container direct-container']/div[@class='breadcrumbs']/ul/li/a")
	end

	def sidebar_heading()
		return $test_driver.find_element(:id, "sidebar").find_element(:xpath => "//h3/a")
	end

	def sidebar_link(i)
		return $test_driver.find_element(:id, "content").find_element(:xpath => "//div[@class='container direct-container']/div/div[@class='main']/div[@class='grid-4']/div[@id='sidebar']/ul/li["+i.to_s+"]/a")
	end

	def sidebar_sub_link(i)
		return $test_driver.find_element(:id, "content").find_element(:xpath => "//div[@class='container direct-container']/div/div[@class='main']/div[@class='grid-4']/div[@id='sidebar']/ul/li[@class='active']/ul/li["+i.to_s+"]/a")
	end

	def closest_office_details()
		return $test_driver.find_element(:id, "closest-office-details")
	end

	def office_name()
		return $test_driver.find_element(:class, "office-name")
	end

	def office_details_link()
		return $test_driver.find_element(:partial_link_text, "Office Details")
	end

	def fao_link()
		return $test_driver.find_element(:partial_link_text, "Find Another Office")
	end

	def schedule_cta
		return $test_driver.find_element(:link_text, "Schedule a New Patient Appointment")
	end

	def youtube_player()
		return $test_driver.find_element(:id, "player")
	end

	def youtube_player_div()
		return $test_driver.find_element(:id, "player").find_element(:xpath => "//div/div")
	end
end