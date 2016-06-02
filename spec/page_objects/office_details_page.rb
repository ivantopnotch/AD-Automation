class OfficeDetailsPage
	def initialize()
		#@wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
		@scroll_sleep_time = 3
	end

	def breadcrumbs()
		return $test_driver.find_element(:class, "breadcrumbs")	
	end

	def sidebar_link(i)
		return $test_driver.find_element(:xpath => "//div[@id='sidebar']/ul[@class='office-menu']/li["+i.to_s+"]")
	end

	#Billboard stuff

	def billboard_bar()
		return $test_driver.find_element(:id, "office-detail-bar")
	end

	def office_address()
		return $test_driver.find_element(:class, "address")
	end

	def get_directions_link()
		return $test_driver.find_element(:class, "get-directions")
	end

	def phone_number()
		return $test_driver.find_element(:id, "office-phone")
	end

	def office_hours_link()
		return $test_driver.find_element(:xpath => "//div[@class='office-hours-container']/a[@class='office-hours-toggler']")
	end

	def office_hours()
		return $test_driver.find_element(:class, "office-hours-container")
	end

	def owned_and_operated()
		return $test_driver.find_element(:xpath => "//p[@class='tagline']")
	end

	def schedule_cta()
		return $test_driver.find_element(:class, "schedule-an-appointment")
	end

	def other_offices()
		return $test_driver.find_element(:xpath => "//div[@class='grid-third'][3]/p[@class='different-location']/a")
	end

	def find_an_office()
		return $test_driver.find_element(:xpath => "//div[@id='office-location']/p[@class='different-location']/a")
	end

	#About this office
	def office_picture()
		return $test_driver.find_element(:class, "about-office-image")
	end

	def office_text()
		return $test_driver.find_element(:class, "about-office-text")
	end

	def dentist_list()
		return $test_driver.find_element(:class, "dentists-list")
	end

	def service_list()
		return $test_driver.find_element(:class, "services-offered")
	end

	def green_tooltips()
		return $test_driver.find_elements(:class, "popover")
	end

	def shadowbox()
		return $test_driver.find_element(:xpath => "//div[@class='popover active']/div[@class='infobox']")
	end

	def shadowbox_close_cta()
		return $test_driver.find_element(:xpath => "//div[@class='popover active']/div[@class='infobox']/div[@class='infobox-close']")
	end

	#Pricing and offers
	def anchor_links()
		return $test_driver.find_elements(:xpath => "//div[@class='internal-links']/a")
	end

	def return_to_top_links()
		return $test_driver.find_elements(:partial_link_text, "Return to the top")
	end

	#Elements that are anchored to
	def general_dentistry()
		return $test_driver.find_element(:id, "general-dentistry")
	end

	def full_dentures()
		return $test_driver.find_element(:id, "full-dentures")
	end

	def partial_dentures()
		return $test_driver.find_element(:id, "partial-dentures")
	end

	def special_offers()
		return $test_driver.find_element(:id, "special-offers")
	end

	def payment_policy()
		return $test_driver.find_element(:id, "payment-policy")
	end

	def refund_policy()
		return $test_driver.find_element(:id, "refund-policy")
	end

	def request_a_refund()
		return $test_driver.find_element(:id, "request-a-refund")
	end

	def general_dentistry_offer()
		return $test_driver.find_element(:xpath => "//div[@id='general-dentistry']/div[@class='banner']")
	end

	def general_dentistry_list()
		return $test_driver.find_element(:xpath => "//div[@id='general-dentistry']/div[@class='services services-general']")
	end

	def denture_comp_chart_links()
		return $test_driver.find_elements(:partial_link_text, "See our denture comparison chart")
	end

	def full_dentures_table()
		return $test_driver.find_element(:xpath => "//div[@id='pricing-and-offers']/div[@class='tab-section'][2]/div[2]")
	end

	def partial_dentures_table()
		return $test_driver.find_element(:xpath => "//div[@id='pricing-and-offers']/div[@class='tab-section'][2]/div[4]")
	end

	def replacement_cells()
		return $test_driver.find_elements(:class, "service-even")
	end

	def first_time_cells()
		return $test_driver.find_elements(:class, "service-odd")
	end

	def see_full_links()
		return $test_driver.find_elements(:link_text, "See Full Price List")
	end

	def collapse_links()
		return $test_driver.find_elements(:link_text, "Collapse")
	end

	def terms_conditions_links()
		return $test_driver.find_elements(:class, "more-offer-details")
	end

	def terms_modal()
		return $test_driver.find_element(:xpath => "//div[@class='modal-content grid-half offer-modal modal-global']")
	end

	def modal_close()
		return $test_driver.find_element(:xpath => "//span[@class='icon icon-cancel-circle modal-close']")
	end

	def print_offer_links()
		return $test_driver.find_elements(:class, "print-office-prices")
	end

	#Dentures & Partials page
	def full_anchor_link()
		return $test_driver.find_element(:link_text, "Full Dentures")
	end

	def partial_anchor_link()
		return $test_driver.find_element(:link_text, "Partial Dentures")
	end

	def pricing_rows()
		return $test_driver.find_elements(:xpath => "//table/tbody/tr[3]/td[@class='category']")
	end

	def appearance_rows()
		return $test_driver.find_elements(:xpath => "//table/tbody/tr[5]/td[@class='category']")
	end

	def material_rows()
		return $test_driver.find_elements(:xpath => "//table/tbody/tr[7]/td[@class='category']")
	end

	def warranty_rows()
		return $test_driver.find_elements(:xpath => "//table/tbody/tr[9]/td[@class='category']")
	end

	def pricing_offers_links()
		return $test_driver.find_elements(:partial_link_text, "See Pricing &amp; Offers For More Details")
	end

	#Insurance and financing page
	def insurance_logos()
		return $test_driver.find_elements(:class, "insurance-company-logo")
	end

	def insurance_providers()
		return $test_driver.find_element(:id, "providers-list")
	end

	def third_party_financing()
		return $test_driver.find_element(:id, "financing-near-you")
	end

	def financing_tile()
		return $test_driver.find_element(:class, "finance-info-container")
	end
end