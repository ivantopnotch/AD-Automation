class DenturesPage
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

	#Carousel stuff
	def current_slide()
		return $test_driver.find_element(:xpath => "//div[@class='slick-slide slick-current slick-active']")
	end

	def slide(i)
		return $test_driver.find_element(:xpath => "//div[@class='slick-content']/div[@class='slick slick-initialized slick-slider']/div[@class='slick-list draggable']/div[@class='slick-track']/div["+i.to_s+"]")
	end

	def next_arrow_cta()
		return $test_driver.find_element(:xpath => "//button[@class='slick-next slick-arrow']")
	end

	def prev_arrow_cta()
		return $test_driver.find_element(:xpath => "//button[@class='slick-prev slick-arrow']")
	end

	#Dentures landing page
	def compare_dentures_cta()
		return $test_driver.find_element(:partial_link_text, "Compare Dentures")
	end

	def money_back1_link()
		return $test_driver.find_element(:link_text, "your Aspen Dental practice will make them right or you’ll get your money back")
	end

	def denture_lab_link()
		return $test_driver.find_element(:link_text, "onsite denture lab")
	end

	def money_back2_link()
		return $test_driver.find_element(:link_text, "Denture Money Back Guarantee")
	end

	def warranty_link()
		return $test_driver.find_element(:link_text, "warranty")
	end

	def denture_style_link()
		return $test_driver.find_element(:link_text, "seven denture styles")
	end

	def view_details_cta()
		return $test_driver.find_element(:partial_link_text, "View details")
	end

	#Dentures made affordable page
	def money_back_cta()
		return $test_driver.find_element(:partial_link_text, "Our Money Back Guarantee")
	end

	def seven_styles_link()
		return $test_driver.find_element(:link_text, "seven styles of dentures")
	end

	#Denture cost page
	def local_office_link()
		return $test_driver.find_element(:link_text, "local Aspen Dental office page")
	end

	def denture_offer()
		return $test_driver.find_element(:id, "dentures").find_element(:xpath => "//div[@class='main']/div[@class='grid-8']/div[@class='content']/div[1]/h1/a/img")
	end

	def click_here_link()
		return $test_driver.find_element(:link_text, "Click here")
	end

	#Denture warranties page
	def comfilytes_link()
		return $test_driver.find_element(:link_text, "ComfiLytes®")
	end

	def naturalytes_link()
		return $test_driver.find_element(:link_text, "NaturaLytes®")
	end

	def flexilytes_link()
		return $test_driver.find_element(:link_text, "FlexiLytes®")
	end

	def flexilytes_combo_link()
		return $test_driver.find_element(:link_text, "FlexiLytes Combo®")
	end

	def classic_full_link()
		return $test_driver.find_element(:link_text, "Classic Full")
	end

	def basic_full_link()
		return $test_driver.find_element(:link_text, "Basic Full")
	end

	def cast_partial_link()
		return $test_driver.find_element(:link_text, "Cast Partial")
	end

	#Compare dentures page
	def denture_offer2()
		return $test_driver.find_element(:id, "dentures").find_element(:xpath => "//div[@class='main']/div[@class='grid-8']/div[@class='content']/p[2]/a/img")
	end

	def full_dentures_anchor()
		return $test_driver.find_element(:xpath => "//div[@id='dentures']/div[@class='main']/div[@class='grid-8']/div[@class='content']/div[@class='dentures']/div[@class='internal-links']/a[1]")
	end

	def partial_dentures_anchor()
		return $test_driver.find_element(:xpath => "//div[@id='dentures']/div[@class='main']/div[@class='grid-8']/div[@class='content']/div[@class='dentures']/div[@class='internal-links']/a[2]")
	end

	def full_dentures_container()
		return $test_driver.find_element(:id,"full-dentures")
	end

	def partial_dentures_container()
		return $test_driver.find_element(:id, "partial-dentures")
	end

	def full_denture_image_link(i)
		return $test_driver.find_element(:xpath => "//div[@id='full-dentures']/div[@class='comparison-table']/table/tbody/tr[2]/td[@class='denture-image']["+i.to_s+"]/a/img")
	end

	def partial_denture_image_link(i)
		return $test_driver.find_element(:xpath => "//div[@id='partial-dentures']/div[@class='comparison-table']/table/tbody/tr[2]/td[@class='denture-image']["+i.to_s+"]/a/img")
	end

	def office_details_links()
		return $test_driver.find_elements(:link_text, "See Office Details Page for Pricing Information")
	end

	#Denture quality page
	def basic_link()
		return $test_driver.find_element(:link_text, "Basic")
	end

	def classic_link()
		return $test_driver.find_element(:link_text, "Classic")
	end

	def naturalytes_link2()
		return $test_driver.find_element(:link_text, "NaturaLytes")
	end

	def comfilytes_link2()
		return $test_driver.find_element(:link_text,"ComfiLytes")
	end

	def flexilytes_combo_link2()
		return $test_driver.find_element(:link_text, "FlexiLytes Combo")
	end

	def flexilytes_link2()
		return $test_driver.find_element(:link_text, "FlexiLytes")
	end
end