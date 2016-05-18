require 'spec_helper'
require 'two_column_spec'

describe "Oral Health pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	tcp = TwoColumnPage.new()
	oral_health = OralHealthPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can read oral health pages correctly" do
		$logger.info("User can read oral health pages correctly")

		it " - Sidebar" do
			$logger.info("Sidebar")
			#Click oral health link on header
			header.dropdown(6).click
			#Load and modify page titles from json
			parsed = JSON.parse(open("spec/page_titles.json").read)
			sub_titles = [parsed["oral-health"]["brushing"],parsed["oral-health"]["flossing"]]
			parsed["oral-health"].delete("brushing")
			parsed["oral-health"].delete("flossing")
			page_titles = parsed["oral-health"].values
			page_titles.insert(2, sub_titles)

			tc.test_sidebar_links(parsed["top-pages"]["oral-health"],page_titles)
		end

		it " - Oral Health landing page" do
			$logger.info("Oral Health landing page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["top-pages"]["oral-health"]
			header.dropdown(6).click
			wait.until { $test_driver.title.include? title }

			#Billboard
			tc.billboard
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health",nil,"Oral Health")
			#Test page links
			test_link_back(oral_health.brush_cap_link,title,parsed["oral-health"]["brushing"])
			test_link_back(oral_health.floss_cap_link,title,parsed["oral-health"]["flossing"])
			test_link_back(oral_health.visit_dentist_link,title,parsed["what-to-expect"]["on-going-care-appointment"])
			test_link_back(oral_health.call_link,title,parsed["top-pages"]["FAO"])
			test_link_back(oral_health.brushing_link,title,parsed["oral-health"]["brushing"])
			test_link_back(oral_health.flossing_link,title,parsed["oral-health"]["flossing"])
			test_link_back(oral_health.here_links[0],title,parsed["oral-health"]["cavities"])
			test_link_back(oral_health.gingivitis_link,title,parsed["oral-health"]["glossary"])
			test_link_back(oral_health.here_links[1],title,parsed["oral-health"]["gum-disease"])
			test_link_back(oral_health.here_links[2],title,parsed["oral-health"]["TMJ"])
			test_link_back(oral_health.brush_lc_link,title,parsed["oral-health"]["brushing"])
			test_link_back(oral_health.floss_lc_link,title,parsed["oral-health"]["flossing"])
			test_link_back(oral_health.oral_cancer_link,title,parsed["oral-health"]["mouth-throat-cancer"])
			test_link_back(oral_health.gum_disease_link,title,parsed["oral-health"]["gum-disease"])

			tc.test_closest_office_details(title)
		end

		it " - Oral Health and Overall Health page" do
			$logger.info("Oral Health and Overall Health page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["oral-health-overall-health"]
			# Hover over dropdown and click glossary link
			tc.navigate_header(6,1,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","oral-health-and-overall-health","Oral Health","Oral Health And Overall Health")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Oral Hygiene page" do
			$logger.info("Oral Hygiene page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["oral-hygiene"]
			tc.navigate_header(6,2,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","oral-hygiene","Oral Health","Oral Hygiene")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Brushing page" do
			$logger.info("Brushing page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["oral-health"]["brushing"]
			#Navigate to oral hygiene page first
			tc.navigate_header(6,2,parsed["oral-health"]["oral-hygiene"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			#Make sure we ended up at brushing page
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","oral-hygiene","Oral Health","Oral Hygiene","brushing","Brushing")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Flossing page" do
			$logger.info("Flossing page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["oral-health"]["flossing"]
			#Navigate to oral hygiene page first
			tc.navigate_header(6,2,parsed["oral-health"]["oral-hygiene"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(2).displayed? }
			tcp.sidebar_sub_link(2).click
			#Make sure we ended up at flossing page
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","oral-hygiene","Oral Health","Oral Hygiene","flossing","Flossing")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Gum Disease page" do
			$logger.info("Gum Disease page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["gum-disease"]
			tc.navigate_header(6,3,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","gum-disease","Oral Health","Gum Disease")
			#Test links
			wait.until { oral_health.choosemyplate_link.displayed? }
			js_scroll_up(oral_health.choosemyplate_link)
			oral_health.choosemyplate_link.click
			#This link opens in a new tab
			$test_driver.switch_to.window( $test_driver.window_handles.last )
			wait.until { $test_driver.current_url.include? "choosemyplate.gov" }
			if ENV['BROWSER_TYPE'] == 'IE' #IE needs to be tricked into not prompting the user to close the window
				$test_driver.execute_script("window.open('', '_self', ''); window.close();")
			else
				$test_driver.execute_script("window.close();")
			end
			$test_driver.switch_to.window( $test_driver.window_handles.first )
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Cavities page" do
			$logger.info("Cavities page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["oral-health"]["cavities"]
			tc.navigate_header(6,4,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","cavities","Oral Health","Cavities")
			#Test links
			test_link_back(oral_health.brushing_link,title,parsed["oral-health"]["brushing"])
			test_link_back(oral_health.flossing_link,title,parsed["oral-health"]["flossing"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Mouth Sores & Spots page" do
			$logger.info("Mouth Sores & Spots page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["mouth-sores"]
			tc.navigate_header(6,5,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","mouth-sores-spots","Oral Health","Mouth Sores & Spots")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Mouth & Throat Cancer page" do
			$logger.info("Mouth & Throat Cancer page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["mouth-throat-cancer"]
			tc.navigate_header(6,6,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","mouth-throat-cancer","Oral Health","Mouth & Throat Cancer")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - TMJ page" do
			$logger.info("TMJ page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["oral-health"]["TMJ"]
			tc.navigate_header(6,7,title)
			#Breadcrumbs
			tc.test_breadcrumbs("oral-health","tmj","Oral Health","TMJ")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Glossary page" do
			$logger.info("Glossary page")
			forsee.add_cookies()
			tc.navigate_header(6,8,JSON.parse(open("spec/page_titles.json").read)["oral-health"]["glossary"])
			tc.test_breadcrumbs("oral-health","dental-terms-glossary","Oral Health","Dental Terms Glossary")

			#Test oral_health anchors
			$logger.info("Glossary anchors")
			oral_health.items.each do |elem|
				#Click oral_health item
				js_scroll_up(elem,true)
				elem.click
				# Make sure we are anchored to the id
				wait.until { oral_health.anchor(elem.attribute("href")).displayed? }
			end

			#Test all 'Back to top' links
			$logger.info("'Back to top' links")
			oral_health.back_to_top_links.each do |link|
				#Make sure its anchor is correct
				expect(link.attribute("href").split("#").last).to eql "content"
				#Make sure we're anchored correctly upon click
				js_scroll_up(link,true)
				link.click
				wait.until { oral_health.content.displayed? }
			end
		end
	end
end