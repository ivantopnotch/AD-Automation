require 'spec_helper'
require 'two_column_spec'

describe "Site map pages functionality" do
	site_map = SiteMapPage.new()
	footer = FooterPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	forsee = ForseePage.new()

	describe " - User can read site map pages correctly" do
		$logger.info("User can read site map pages correctly")

		it " - Map links" do
			$logger.info("Map links")
			forsee.add_cookies()
			footer.site_map_link.click
			wait.until { $test_driver.title.include? "Site Map" }

			#Load page titles from json
			file = open("spec/page_titles.json")
			parsed = JSON.parse(file.read)
			expected_titles = parsed["top-pages"].values

			#Modify to match site map
			indent_titles = [parsed["oral-health"]["brushing"], parsed["oral-health"]["flossing"]]
			parsed["oral-health"].delete("brushing")
			parsed["oral-health"].delete("flossing")
			expected_titles[13] = parsed["top-pages"]["my-account"]

			expected_titles += parsed["dental-services"].values
			expected_titles += parsed["dentures"].values
			expected_titles += parsed["reviews"].values
			expected_titles += parsed["what-to-expect"].values
			expected_titles += parsed["oral-health"].values
			expected_titles += parsed["about"].values
			expected_titles += parsed["my-account"].values
			expected_titles += indent_titles

			for i in 0 .. expected_titles.length-1
				links = site_map.map_links + site_map.map_indent_links + site_map.map_double_indent_links #Prevent stale reference errors
				#Open link in new tab and switch to it
				wait.until { links[i].displayed? }
				test_link_back(links[i], "Site Map", expected_titles[i])
			end
		end

		it " - Offices links" do
			$logger.info("Offices links")
			forsee.add_cookies()
			footer.office_listings_link.click
			wait.until { $test_driver.title.include? "Site Map" }

			#Verify all office links
			for i in 0 .. site_map.office_links.length-1
				links = site_map.office_links
				#Store office name (without state; title on the page doesn't include it)
				office_name = links[i].attribute("text").lstrip.split(",").first.tr('.','').downcase
				wait.until { links[i].displayed? }
				#Open link
				test_link_back(links[i], "Site Map", office_name, true)
			end
		end
	end
end