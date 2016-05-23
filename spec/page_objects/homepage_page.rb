class HomepagePage

	def hero_schedule_cta()
		$test_driver.find_element(:xpath => "//div[@class='slide-content']/a[@class='button']")
	end

	def hero_terms_conditions_link()
		$test_driver.find_element(:link_text, "Terms and conditions apply")
	end

	def closest_office_details()
		$test_driver.find_element(:id, "closest-office-details")
	end

	def dynamic_office_link()
		$test_driver.find_element(:class, "office-name")
	end

	def office_owner()
		$test_driver.find_element(:class, "office-owner")
	end

	def office_details()
		$test_driver.find_element(:class, "office-details")
	end

	def office_details_link()
		$test_driver.find_element(:partial_link_text, "Office Details")
	end

	def schedule_cta()
		$test_driver.find_element(:link_text, "Schedule a New Patient Appointment")
	end

	def find_another_office_link()
		$test_driver.find_element(:partial_link_text, "Find Another Office")
	end

	def first_offer_cta()
		$test_driver.find_element(:xpath => "//div[@class='offer-image first']")
	end

	def second_offer_cta()
		$test_driver.find_element(:xpath => "//div[@class='offer-image second']")
	end

	def offer_modal()
		$test_driver.find_element(:class, "modal-content")
	end

	def print_cta()
		$test_driver.find_element(:class, "modal-print")
	end

	def close_modal_cta()
		$test_driver.find_element(:class, "icon-cancel-circle")
	end

	#Testimonials tile
	def testimonials_tile()
		$test_driver.find_element(:class, "social")
	end

	def more_reviews_cta()
		$test_driver.find_element(:partial_link_text, "See More Reviews")
	end

	#This link opens in new tab
	def like_on_facebook_link()
		$test_driver.find_element(:partial_link_text, "Like us on Facebook")
	end

	#Emergency tile
	def emergency_tile()
		$test_driver.find_element(:class, "emergency")
	end

	def emergency_number()
		$test_driver.find_element(:id, "emergency-number")
	end

	def contact_us_link()
		$test_driver.find_element(:link_text, "Contact Us")
	end

	def forms_tile()
		$test_driver.find_element(:class, "forms")
	end

	def download_forms_cta()
		$test_driver.find_element(:partial_link_text, "Download Forms")
	end

	#Patient forms page
	def download_pdf_ctas()
		$test_driver.find_elements(:xpath => "//a[@class='button download-patient-forms']")
	end
end