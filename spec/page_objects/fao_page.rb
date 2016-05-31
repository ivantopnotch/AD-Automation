class FaoPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	#Search form
	def location_field()
		return $test_driver.find_element(:id, "location")
	end

	def search_cta()
		return $test_driver.find_element(:xpath => "//button[@class='icon icon-search']")
	end

	def office_count()
		return $test_driver.find_element(:class, "office-count")
	end

	def limiter()
		return $test_driver.find_element(:class, "limiter")
	end

	def location_results()
		return $test_driver.find_elements(:xpath => "//ol[@id='available-locations']/li")
	end

	def all_offices_toggle()
		return $test_driver.find_element(:class, "toggle-all-offices")
	end

	#Mini map
	def mini_map()
		return $test_driver.find_element(:id, "map-wrapper")
	end

	def expand_minimize_cta()
		return $test_driver.find_element(:xpath => "//button[@class='button toggle-map']")
	end

	#Search items
	#These all return arrays
	def location_links()
		return $test_driver.find_elements(:class, "location")
	end

	def get_directions_links()
		return $test_driver.find_elements(:link_text, "Get Directions")
	end

	def insurance_links()
		return $test_driver.find_elements(:partial_link_text, "View insurance")
	end

	def pricing_links()
		return $test_driver.find_elements(:partial_link_text, "View pricing")
	end
end