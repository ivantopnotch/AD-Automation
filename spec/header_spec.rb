require 'spec_helper'

def test_dropdown(header, drop_no, page_titles)
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	forsee = ForseePage.new()
	forsee.add_cookies()

	for i in 0 .. page_titles.length-1
		#Hover over dropdown
		wait.until { header.dropdown(drop_no).displayed? }
		$test_driver.action.move_to(header.dropdown(drop_no)).perform
		$test_driver.navigate.back
		start_time = time_now_sec
		while !header.dropdown_link(drop_no,i+1).displayed? do
	    	if time_now_sec >= start_time + 3
	        	fail("Header dropdown #"+drop_no.to_s+", link #"+i.to_s+" did not appear")
	    	end
	    	#Try again
	    	$test_driver.action.move_to(header.dropdown(drop_no)).perform
		end
		#Click link
		header.dropdown_link(drop_no,i+1).click

		#Check page title
		begin
			wait.until { $test_driver.title.include? page_titles[i] }
		rescue Selenium::WebDriver::Error::TimeOutError
			fail("Error loading page " + page_titles[i])
		end
	end
end

describe "Header functionality" do
	header = HeaderPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can use all links in the header correctly" do
		$logger.info("User can use all links in the header correctly")

		#Load page titles from json
		parsed = JSON.parse(open("spec/page_titles.json").read)

		it " - Logo link" do
			$logger.info("Logo link")
			header.logo.click
    		wait.until { $test_driver.title.include? parsed["top-pages"]["home"] }
    	end

		it " - SAA CTA" do
			$logger.info("SAA CTA")
			header.saa_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["SAA"] }
		end

		it " - FAO CTA" do
			$logger.info("FAO CTA")
			header.fao_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["FAO"] }
		end

		it " - 'Search this site' CTA" do
			$logger.info("'Search this site' CTA")
			header.search_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["search"] }
		end

		it " - 'My account' CTA" do
			$logger.info("'My account' CTA")
			header.my_account_cta.click
			wait.until { $test_driver.title.include? parsed["top-pages"]["my-account"] }
		end

		it " - Dental Services dropdown" do
			$logger.info("Dental Services dropdown")
			#Test link
			header.dropdown(1).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["dental-services"] }
			#Modify page titles to match header
			parsed["dental-services"].delete("root-canal-cost")
			parsed["dental-services"].delete("dental-implant-cost")
			parsed["dental-services"].delete("teeth-whitening")
			parsed["dental-services"].delete("dental-veneers")
			test_dropdown(header,1,parsed["dental-services"].values)
		end

		it " - Dentures dropdown" do
			$logger.info("Dental Services dropdown")
			header.dropdown(2).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["dentures"] }
			parsed["dentures"].delete("denture-cost")
			parsed["dentures"].delete("denture-warranties")
			parsed["dentures"].delete("cast-partial")
			parsed["dentures"].delete("flexilytes")
			parsed["dentures"].delete("flexilytes-combo")
			parsed["dentures"].delete("basic-full")
			parsed["dentures"].delete("classic-full")
			parsed["dentures"].delete("naturalytes")
			parsed["dentures"].delete("comfilytes")
			parsed["dentures"].delete("when-to-get-dentures")
			parsed["dentures"].delete("denture-facts-mythos")
			parsed["dentures"].delete("how-to-clean-dentures")
			test_dropdown(header,2,parsed["dentures"].values)
		end

		it " - Pricing & offers link" do
			$logger.info("Pricing & offers link")
			header.dropdown(3).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["pricing-offers"] }
		end

		it " - Patient reviews dropdown" do
			$logger.info("Patient reviews dropdown")
			header.dropdown(4).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["reviews"] }
			test_dropdown(header,4,parsed["reviews"].values)
		end

		it " - What to expect dropdown" do
			$logger.info("What to expect dropdown")
			header.dropdown(5).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["what-to-expect"] }
			test_dropdown(header,5,parsed["what-to-expect"].values)
		end

		it " - Oral health dropdown" do
			$logger.info("Oral health dropdown")
			header.dropdown(6).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["oral-health"] }
			parsed["oral-health"].delete("brushing")
			parsed["oral-health"].delete("flossing")
			test_dropdown(header,6,parsed["oral-health"].values)
		end

		it " - About dropdown" do
			$logger.info("About dropdown")
			header.dropdown(7).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["about"] }
			test_dropdown(header,7,parsed["about"].values)
		end

		it " - FAQs dropdown" do
			$logger.info("FAQs dropdown")
			header.dropdown(8).click
			wait.until { $test_driver.title.include? parsed["top-pages"]["faqs"] }
			test_dropdown(header,8,parsed["faqs"].values)
		end
	end
end