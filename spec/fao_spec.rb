require 'spec_helper'

def perform_search(query, do_sleep = true)
	fao = FaoPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	fao.location_field.clear
	fao.location_field.send_keys(query)
	fao.search_cta.click
	if do_sleep
		sleep 1
	end
end

describe "Find An Office page functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	fao = FaoPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	parsed = JSON.parse(open("spec/page_titles.json").read)
	title = parsed["top-pages"]["FAO"]

	describe "User can use Find An Office correctly" do
		$logger.info("User can use Find An Office correctly")

		it " - Mini map" do
			$logger.info("Mini map")
			forsee.add_cookies()

			#Navigate to page
			header.fao_cta.click
			wait.until { $test_driver.title.include? title }

			#Verify existance of map
			wait.until { fao.mini_map.displayed? }
			#Expand it
			num_retry = 0
			begin
				fao.expand_minimize_cta.click
				wait.until { fao.mini_map.attribute("style").include? "width: 585px" }
			rescue Selenium::WebDriver::Error::TimeOutError
				retry if (num_retry += 1) == 1
			end
			#Minimize it
			num_retry = 0
			begin
				fao.expand_minimize_cta.click
				wait.until { fao.mini_map.attribute("style").include? "width: 404px" }
			rescue Selenium::WebDriver::Error::TimeOutError
				retry if (num_retry += 1) == 1
			end
		end

		it " - Search" do
			$logger.info("Search")
			forsee.add_cookies()

			header.fao_cta.click
			wait.until { $test_driver.title.include? title }
			wait.until { fao.office_count.displayed? }

			#Search by zip, then by City, State
			searches = ["13039", "Cicero, NY"]
			searches.each do |search|
				text = fao.office_count.attribute("innerHTML") #So we can make sure it changes
				perform_search(search,false)
				wait.until { fao.office_count.attribute("innerHTML") != text }
				expect(fao.office_count.attribute("innerHTML").include? search)
				#These searches should give us the full five
				wait.until { fao.location_results[4].displayed? }
				sleep 1
			end

			#See all offices
			js_scroll_up(fao.all_offices_toggle)
			fao.all_offices_toggle.click
			wait.until { fao.location_results[fao.location_results.length-1].displayed? }
			#Make sure it no longer says "Displaying 1-5"
			expect(fao.limiter.attribute("innerHTML").include? " Displaying 1-5").to eql true
		end

		it " - Search links" do
			$logger.info("Search links")
			forsee.add_cookies()
			query = "13039" #Search query

			header.fao_cta.click
			wait.until { $test_driver.title.include? title }
			wait.until { fao.office_count.displayed? }

			#Choose a random result
			no = rand(0 .. 4)

			#Perform search
			perform_search(query)

			#Test google maps link
			sleep 1
			test_link_tab(fao.get_directions_links[no], nil, "https://www.google.com/maps")
			
			#Test the rest
			#Can't do this in a loop because you'll get a StaleElementReferenceError
			sleep 1
			test_link_back(fao.location_links[no], title, parsed["office"]["about-office"])
			perform_search(query) #Have to repeat search after we reload page
			test_link_back(fao.insurance_links[no], title, parsed["office"]["insurance-financing"])
			perform_search(query)
			test_link_back(fao.pricing_links[no], title, parsed["office"]["pricing-offers"])
		end

	end
end