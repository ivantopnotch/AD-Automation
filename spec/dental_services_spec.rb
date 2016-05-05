require 'spec_helper'
require 'two_column_spec'

describe "Dental Services pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	tcp = TwoColumnPage.new()
	dental_services = DentalServicesPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can read dental services pages correctly" do
		$logger.info("User can read dental services pages correctly")

		#Base breadcrumb for all pages
		breadcrumb = ["dental-services","Dental Services"]

		it " - Sidebar" do
			$logger.info("Sidebar")
			#Click oral health link on header
			header.dropdown(1).click
			#Load and modify page titles from json
			parsed = JSON.parse(open("spec/page_titles.json").read)
			sub_titles1 = [parsed["dental-services"]["root-canal-cost"]]
			parsed["dental-services"].delete("root-canal-cost")
			sub_titles2 = [parsed["dental-services"]["dental-implant-cost"]]
			parsed["dental-services"].delete("dental-implant-cost")
			sub_titles3 = [parsed["dental-services"]["teeth-whitening"],parsed["dental-services"]["dental-veneers"]]
			parsed["dental-services"].delete("teeth-whitening")
			parsed["dental-services"].delete("dental-veneers")

			page_titles = parsed["dental-services"].values
			page_titles.insert(6, sub_titles1)
			page_titles.insert(11, sub_titles2)
			page_titles.push(sub_titles3)

			tc.test_sidebar_links(parsed["top-pages"]["dental-services"],page_titles)
		end

		it " - Dental Services landing page" do
			$logger.info("Dental Services landing page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["top-pages"]["dental-services"]
			header.dropdown(1).click
			wait.until { $test_driver.title.include? title }

			#Billboard
			tc.billboard
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],nil,breadcrumb[1])

			#Test link(s)
			test_link_back(dental_services.emergency_cta, title, parsed["dental-services"]["emergency-care"])

			tc.test_closest_office_details(title)
		end

		it " - Emergency care page" do
			$logger.info("Emergency care page")
			forsee.add_cookies()
			title = JSON.parse(open("spec/page_titles.json").read)["dental-services"]["emergency-care"]
			# Hover over dropdown and click link
			tc.navigate_header(1,1,title)
		  	#Billboard
			tc.billboard
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"emergency-dental-care",breadcrumb[1],"Emergency Dental Care")
			#Test phone number DNIs
			if dental_services.phone_number.text != "(877) 277-4479"
				fail("Default DNI number did not match, was instead: " + dental_services.phone_number.text)
			end
			base_url = $test_driver.current_url
			utm_sources = ["google","yp","yelp"]
			dni_numbers = ["(877) 277-4354","(877) 277-4403","(877) 929-0874"]
			for i in 0 .. dni_numbers.length-1
				$test_driver.navigate.to(base_url + "?utm_source=" + utm_sources[i])
				wait.until { dental_services.phone_number.displayed? }
				sleep 1 #Give time for phone no. to switch dynamically
				if dental_services.phone_number.text != dni_numbers[i]
					fail(utm_sources[i] + " DNI number did not match, was instead: " + dental_services.phone_number.text)
				end
			end

			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Checkup page" do
			$logger.info("Checkup page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["check-up"]
			tc.navigate_header(1,2,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"checkups",breadcrumb[1],"Checkups")
			#Test links
			test_link_back(dental_services.oral_health_link, title, parsed["oral-health"]["oral-health-overall-health"])
			test_link_back(dental_services.click_here_link, title, parsed["what-to-expect"]["on-going-care-appointment"])
			test_link_back(dental_services.learn_more_cta, title, parsed["what-to-expect"]["first-dental-visit"])
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - TMJ page" do
			$logger.info("TMJ page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["peridontal-disease"]
			tc.navigate_header(1,3,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"treatment-of-periodontal-disease",breadcrumb[1],"Treatment Of Periodontal Disease")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Tooth Extraction page" do
			$logger.info("Tooth Extraction page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["tooth-extraction"]
			tc.navigate_header(1,4,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"tooth-extraction",breadcrumb[1],"Tooth Extraction")
			#Links
			test_link_back(dental_services.overcoming_anxiety_link, title, parsed["what-to-expect"]["overcoming-dental-anxiety"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end
		
		it " - Tooth Fillings page" do
			$logger.info("Tooth Extraction page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["fillings"]
			tc.navigate_header(1,5,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"fillings",breadcrumb[1],"Fillings")
			#Links
			test_link_back(dental_services.overcoming_anxiety_link, title, parsed["what-to-expect"]["overcoming-dental-anxiety"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Root Canal page" do
			$logger.info("Root Canal page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["root-canal"]
			tc.navigate_header(1,6,parsed["dental-services"]["root-canal"])
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"root-canal",breadcrumb[1],"Root Canal")
			#Links
			test_link_back(dental_services.overcoming_anxiety_link, title, parsed["what-to-expect"]["overcoming-dental-anxiety"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Root Canal Cost page" do
			$logger.info("Root Canal Cost page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["root-canal-cost"]
			tc.navigate_header(1,6,parsed["dental-services"]["root-canal"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"root-canal",breadcrumb[1],"Root Canal","root-canal-cost","Root Canal Cost")
			#Links
			test_link_back(dental_services.gum_disease_link, title, parsed["oral-health"]["gum-disease"])
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Dental Crowns page" do
			$logger.info("Dental Crowns page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["dental-crowns"]
			tc.navigate_header(1,7,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"dental-crowns",breadcrumb[1],"Dental Crowns")
			#Links
			test_link_back(dental_services.other_systems_link, title, parsed["oral-health"]["oral-health-overall-health"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Dental Bridges page" do
			$logger.info("Dental Bridges page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["dental-bridges"]
			tc.navigate_header(1,8,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"dental-bridges",breadcrumb[1],"Dental Bridges")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Oral Surgery page" do
			$logger.info("Oral Surgery page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["oral-surgery"]
			tc.navigate_header(1,9,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"oral-surgery",breadcrumb[1],"Oral Surgery")
			#Links
			titles = [parsed["oral-health"]["cavities"],parsed["oral-health"]["glossary"],parsed["dental-services"]["dental-implants"]]
			titles += [parsed["oral-health"]["TMJ"],parsed["oral-health"]["glossary"],parsed["oral-health"]["glossary"],parsed["oral-health"]["glossary"]]
			titles += [parsed["dental-services"]["tooth-extraction"],parsed["oral-health"]["glossary"],parsed["oral-health"]["glossary"],parsed["oral-health"]["glossary"]]
			for i in 0 .. dental_services.oral_surgery_links.length-1
				test_link_back(dental_services.oral_surgery_links[i], title, titles[i])
			end
			test_link_back(dental_services.overcoming_anxiety_link, title, parsed["what-to-expect"]["overcoming-dental-anxiety"])
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Dental Implants page" do
			$logger.info("Dental Implants page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["dental-implants"]
			tc.navigate_header(1,10,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"dental-implants",breadcrumb[1],"Dental Implants")
			#Link
			test_link_back(dental_services.contact_link, title, parsed["top-pages"]["FAO"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Dental Implants Cost page" do
			$logger.info("Dental Implants Cost page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["dental-implant-cost"]
			tc.navigate_header(1,10,parsed["dental-services"]["dental-implants"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"dental-implants",breadcrumb[1],"Dental Implants","dental-implant-cost","Dental Implant Cost")
			#Links
			test_link_back(dental_services.contact_link, title, parsed["top-pages"]["FAO"])
			test_link_back(dental_services.implant_link, title, parsed["dental-services"]["dental-implants"])
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Cosmetic Dentistry page" do
			$logger.info("Cosmetic Dentistry page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["cosmetic-dentistry"]
			tc.navigate_header(1,11,title)
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"cosmetic-dentistry",breadcrumb[1],"Cosmetic Dentistry")
			#Links
			js_scroll_up(dental_services.teeth_whitening_link)
			test_link_back(dental_services.teeth_whitening_link, title, parsed["dental-services"]["teeth-whitening"])
			test_link_back(dental_services.veneers_link, title, parsed["dental-services"]["dental-veneers"])
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Teeth Whitening page" do
			$logger.info("Teeth Whitening page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["teeth-whitening"]
			tc.navigate_header(1,11,parsed["dental-services"]["cosmetic-dentistry"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"cosmetic-dentistry",breadcrumb[1],"Cosmetic Dentistry","teeth-whitening","Teeth Whitening")
			#Closest office container
			tc.test_closest_office_details(title)
		end

		it " - Dental Veneers page" do
			$logger.info("Dental Veneers page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dental-services"]["dental-veneers"]
			tc.navigate_header(1,11,parsed["dental-services"]["cosmetic-dentistry"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(2).click
			wait.until { $test_driver.title.include? title }
			#Breadcrumbs
			tc.test_breadcrumbs(breadcrumb[0],"cosmetic-dentistry",breadcrumb[1],"Cosmetic Dentistry","dental-veneers","Dental Veneers")
			#Youtube video
			tc.test_youtube_player()
			#Closest office container
			tc.test_closest_office_details(title)
		end
	end
end