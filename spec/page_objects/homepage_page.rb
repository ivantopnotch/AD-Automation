class HomepagePage

	def hero_link()
		$test_driver.find_element(:partial_link_text, "/schedule-an-appointment")
	end

	def dynamic_offic_link()
		$test_driver.find_element(:class, "office-name")
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

	def offer_ctas()
		$test_driver.find_element(:class, "more-offer-details")
	end

	def offer_modal()
		$test_driver.find_element(:class, "modal-content")
	end

	def close_modal_cta()
		$test_driver.find_element(:class, "icon-cancel-circle")
	end

	def more_reviews_cta()
		$test_driver.find_element(:partial_link_text, "See More Reviews")
	end

	#This link opens in new tab
	def like_on_facebook_link()
		$test_driver.find_element(:partial_link_text, "Like us on Facebook")
	end

	def contact_us_link()
		$test_driver.find_element(:link_text, "Contact Us")
	end

	def download_forms_cta()
		$test_driver.find_element(:partial_link_text, "Download Forms")
	end
end