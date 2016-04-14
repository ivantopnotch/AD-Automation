class SiteMapPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def map_links()
		return $test_driver.find_element(:id, "content").find_elements(:xpath => "//div[@class='container direct-container']/div[@class='policies padded-vertical']/div[@class='content-box']/p/a")
	end

	def map_indent_links()
		return $test_driver.find_element(:id, "content").find_elements(:xpath => "//div[@class='container direct-container']/div[@class='policies padded-vertical']/div[@class='content-box']/ul/li/a")
	end

	def map_double_indent_links()
		return $test_driver.find_element(:id, "content").find_elements(:xpath => "//div[@class='container direct-container']/div[@class='policies padded-vertical']/div[@class='content-box']/ul/li/ul/li/a")
	end

	def office_links()
		return $test_driver.find_elements(:partial_link_text, ",")
	end
end