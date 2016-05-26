class HmmPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	#Anchors and corrisponding sections
	def partnership_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][1]")
	end

	def partnership_section()
		return $test_driver.find_element(:id, "partnership")
	end

	def about_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][2]")
	end

	def about_section()
		return $test_driver.find_element(:id, "about")
	end

	def schedule_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][3]")
	end

	def schedule_section()
		return $test_driver.find_element(:id, "schedule")
	end

	def impact_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][4]")
	end

	def impact_section()
		return $test_driver.find_element(:id, "impact")
	end

	def gallery_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][5]")
	end

	def gallery_section()
		return $test_driver.find_element(:id, "gallery")
	end

	def faq_cta()
		return $test_driver.find_element(:xpath => "//a[@class='nav-icon'][6]")
	end

	def faq_section()
		return $test_driver.find_element(:id, "faq")
	end

	#In-page links
	def got_your_6_link()
		return $test_driver.find_element(:link_text, "Got Your 6")
	end

	#Carousel stuff
	def slide(i)
		return $test_driver.find_element(:xpath => "//div[@class='owl-wrapper']/div["+i.to_s+"]")
	end

	def next()
		return $test_driver.find_element(:class, "owl-next")
	end

	def prev()
		return $test_driver.find_element(:class, "owl-prev")
	end
end