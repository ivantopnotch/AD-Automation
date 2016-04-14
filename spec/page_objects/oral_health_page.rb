class OralHealthPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def content()
		return $test_driver.find_element(:id, "content")
	end

	def here_link()
		return $test_driver.find_element(:link_text, "here")
	end

	def here_links()
		return $test_driver.find_elements(:link_text, "here")
	end

	#Oral health landing page

	def brush_cap_link()
		return $test_driver.find_element(:link_text, "Brush")
	end

	def floss_cap_link()
		return $test_driver.find_element(:link_text, "Floss")
	end

	def visit_dentist_link()
		return $test_driver.find_element(:link_text, "Visit your dentist")
	end

	def call_link()
		return $test_driver.find_element(:link_text, "Call")
	end

	def brushing_link()
		return $test_driver.find_element(:link_text, "brushing")
	end

	def flossing_link()
		return $test_driver.find_element(:link_text, "flossing")
	end

	def gingivitis_link()
		return $test_driver.find_element(:link_text, "Gingivitis")
	end

	def brush_lc_link()
		return $test_driver.find_element(:link_text, "brush")
	end

	def floss_lc_link()
		return $test_driver.find_element(:link_text, "floss ") #Link text has &nbsp;
	end

	def oral_cancer_link()
		return $test_driver.find_element(:link_text, "oral cancer")
	end

	def gum_disease_link()
		return $test_driver.find_element(:link_text, "gum disease")
	end

	#Gum Disease page

	def choosemyplate_link()
		return $test_driver.find_element(:link_text,"choosemyplate.gov")
	end

	#Glossary page stuff

	#Get all glossary page items
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

end