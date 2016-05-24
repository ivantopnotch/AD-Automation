require 'spec_helper'

#Re-usable test spec
class TwoColumnSpec
	#Allows us to use rspec stuff inside a class
	include RSpec::Mocks::ExampleMethods::ExpectHost
  	include RSpec::Matchers 

	def initialize()
		@wait = Selenium::WebDriver::Wait.new(timeout: 3)
		@two_column = TwoColumnPage.new()
		@forsee = ForseePage.new()
	end

	def billboard()
		@wait.until { @two_column.billboard.displayed? }
	end

	#Navigate to the page you want using the header
	def navigate_header(drop_no, link_no, expected_title)
		$logger.info("Click header dropdown link")
		header = HeaderPage.new()
		#Hover over dropdown until it appears
		@wait.until { header.dropdown(drop_no).displayed? }
		$test_driver.action.move_to(header.dropdown(drop_no)).perform
		start_time = time_now_sec
		while !header.dropdown_link(drop_no,link_no).displayed? do
	    	if time_now_sec >= start_time + 3
	      		fail("Hover menu #" + drop_no.to_s + ", link #" + link_no.to_s + " did not appear")
	    	end
	    	#Try again
	   		$test_driver.action.move_to(header.dropdown(drop_no)).perform
		end

		num_retry = 0
		begin
			#Click dropdown item
			header.dropdown_link(drop_no,link_no).click
			#Check title
			@wait.until { $test_driver.title.include? expected_title }
		rescue Selenium::WebDriver::Error::TimeOutError
			#Try again
			retry if (num_retry += 1) == 1
		end
	end

	def test_closest_office_details(parent_title, sleep_after_back = false)
		$logger.info("Office details")
		timeout = 7
		wait = Selenium::WebDriver::Wait.new(timeout: timeout)

		wait.until { @two_column.closest_office_details.displayed? }
		#Click office name
		begin
			wait.until { @two_column.office_name.displayed? }
		rescue Selenium::WebDriver::Error::TimeOutError
			fail("Closest office details did not load in time on " + parent_title + " page")
		end
		office_name = @two_column.office_name.attribute("text").lstrip.split(",").first.tr('.','').downcase #Store office name (without state)
		test_link_back(@two_column.office_name, parent_title, office_name, true, timeout)
		#Repeat with office details link
		# if sleep_after_back
		# 	sleep 2
		# end
		sleep 2

		#Verify existance of "owned an operated by" and office details
		wait.until { @two_column.operated_info.displayed? }
		expect(@two_column.office_details.displayed?).to eql true

		test_link_back(@two_column.office_details_link, parent_title, office_name, true, timeout)
		#Find another office link
		# if sleep_after_back
		# 	sleep 2
		# end
		sleep 2
		test_link_back(@two_column.fao_link, parent_title, "Find a Dental Office", false, timeout)
		#Schedule appointment CTA
		# if sleep_after_back
		# 	sleep 2
		# end
		sleep 2
		test_link_back(@two_column.schedule_cta, parent_title, "Schedule a Dentist Appointment", false, timeout)
	end

	def test_breadcrumbs(second, third = nil, txSecond = nil, txThird = nil, fourth = nil, txFourth = nil)
		bc = @two_column.breadcrumbs
		#Make sure first one is "home"
		expect(bc[0].attribute("href") ).to eql "https://" + $ad_env + $domain + "/"
		expect(bc[0].attribute("text") ).to eql "Home"
		#Check second
		expect(bc[1].attribute("href").split("/").last).to eql second
		if(txSecond != nil)
			expect(bc[1].attribute("text") ).to eql txSecond
		end
		#Check third, if applicable
		if(third != nil)
			expect(bc[2].attribute("href").split("/").last).to eql third
			if(txThird != nil)
				expect(bc[2].attribute("text") ).to eql txThird
			end
		end
		#Check fourth, if applicable
		if(fourth != nil)
			expect(bc[3].attribute("href").split("/").last).to eql fourth
			if(txFourth != nil)
				expect(bc[3].attribute("text") ).to eql txFourth
			end
		end
	end

	def test_sidebar_links(parent_page_title, page_titles)
		@forsee.add_cookies()
		#Check heading link
		@two_column.sidebar_heading.click
		@wait.until { $test_driver.title.include? parent_page_title }
		#Keep track of sub menus (not links) entered so we can keep xpath indices correct, even if mis-matched with array
		num_sub = 0

		for i in 0 .. page_titles.length-1
			#Handle sub-links
			if page_titles[i].is_a?(Array)
				for j in 0 .. page_titles[i].length-1
					#Click link
					begin
						@wait.until { @two_column.sidebar_sub_link(j+1).displayed? }
						@two_column.sidebar_sub_link(j+1).click
					rescue Selenium::WebDriver::Error::StaleElementReferenceError
						fail("Sidebar item for " + page_titles[i][j] + " disappeared")
					end
					
					#Check page title
					begin
						@wait.until { $test_driver.title.include? page_titles[i][j] }
						#Verify carrot
						expect(@two_column.sidebar_sub_link(j+1).attribute("class") == "active").to eql true
					rescue Selenium::WebDriver::Error::TimeOutError
						$logger.info("Error loading sub page " + page_titles[i][j])
						fail("Error loading sub page " + page_titles[i][j])
					end
				end
				num_sub += 1
			#Handle regular link
			else
				#Click link
				begin
					@wait.until { @two_column.sidebar_link(i+1-num_sub).displayed? }
					@two_column.sidebar_link(i+1-num_sub).click
				rescue Selenium::WebDriver::Error::StaleElementReferenceError
					fail("Sidebar item for " + page_titles[i] + " disappeared")
				end
				
				#Check page title
				begin
					@wait.until { $test_driver.title.include? page_titles[i] }
					#Verify carrot
					expect(@two_column.sidebar_link(i+1).attribute("class") == "active").to eql true
				rescue Selenium::WebDriver::Error::TimeOutError
					$logger.info("Error loading page " + page_titles[i])
					fail("Error loading page " + page_titles[i])
				end #end rescue
			end #end if
		end #End for
	end #End def


	def test_youtube_player(no_text = false)
		$logger.info("Youtube video")
		#Check for "According to the American Dental Association" text
		if(!no_text)
			expect(@two_column.ADA_text.attribute("innerHTML").include? "According to the American Dental Association").to eql true
		end

		#IE doesn't like this at all
		if ENV['BROWSER_TYPE'] == 'IE'
			return
		end

		#Give firefox a minute, he's a little... slow
		if ENV['BROWSER_TYPE'] == 'FIREFOX'
			sleep 3
		end
		$test_driver.switch_to.frame(0)
		#Click video to play
		@two_column.youtube_player.click
		#Make sure it's playing
		@wait.until { @two_column.youtube_player_div.attribute("class").include? "playing-mode" }
		#Switch back to default frame
		@two_column.youtube_player.click #Pause video
		$test_driver.switch_to.default_content
	end
end