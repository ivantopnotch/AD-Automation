require 'spec_helper'
require 'two_column_spec'

def test_carousel(dentures)
	# wait = Selenium::WebDriver::Wait.new(timeout: 3)
	# wait.until { dentures.current_slide.displayed? }
	# #Store all slide contents
	# contents = Array.new(4)
	# for i in 0 .. 3
	# 	contents[i] = dentures.slide(i+2).attribute("innerHTML")
	# end

	# sleep 5
	# for i in 0 .. 3
	# 	dentures.next_arrow_cta.click
	# 	puts dentures.current_slide.attribute("innerHTML")
	# 	sleep 1
	# end
	# sleep 5
	# expect(dentures.current_slide.attribute("data-slick-index")).to eql "1"
	# dentures.next_arrow_cta.click
	# sleep 1
	# dentures.next_arrow_cta.click
	# sleep 3
	# expect(dentures.current_slide.attribute("data-slick-index")).to eql "2"
end

describe "Dentures pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	tcp = TwoColumnPage.new()
	dentures = DenturesPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)

	describe " - User can read dentures pages correctly" do
		$logger.info("User can read dentures pages correctly")

		it " - Sidebar" do
			$logger.info("Sidebar")
			#Click oral health link on header
			header.dropdown(2).click
			#Load and modify page titles from json
			parsed = JSON.parse(open("spec/page_titles.json").read)
			sub_titles1 = [parsed["dentures"]["denture-cost"],parsed["dentures"]["denture-warranties"]]
			parsed["dentures"].delete("denture-cost")
			parsed["dentures"].delete("denture-warranties")

			sub_titles2 = [parsed["dentures"]["cast-partial"],parsed["dentures"]["flexilytes"],parsed["dentures"]["flexilytes-combo"]]
			parsed["dentures"].delete("cast-partial")
			parsed["dentures"].delete("flexilytes")
			parsed["dentures"].delete("flexilytes-combo")

			sub_titles3 = [parsed["dentures"]["basic-full"],parsed["dentures"]["classic-full"],parsed["dentures"]["naturalytes"],parsed["dentures"]["comfilytes"]]
			parsed["dentures"].delete("basic-full")
			parsed["dentures"].delete("classic-full")
			parsed["dentures"].delete("naturalytes")
			parsed["dentures"].delete("comfilytes")

			sub_titles4 = [parsed["dentures"]["when-to-get-dentures"],parsed["dentures"]["denture-facts-mythos"],parsed["dentures"]["how-to-clean-dentures"]]
			parsed["dentures"].delete("when-to-get-dentures")
			parsed["dentures"].delete("denture-facts-mythos")
			parsed["dentures"].delete("how-to-clean-dentures")

			#Inset sub-links
			page_titles = parsed["dentures"].values
			page_titles.insert(1, sub_titles1)
			page_titles.insert(5, sub_titles2) #Make sure to account for previously inserted
			page_titles.insert(7, sub_titles3)
			page_titles.insert(11, sub_titles4)

			tc.test_sidebar_links(parsed["top-pages"]["dentures"],page_titles)
		end

		it " - Dentures landing page" do
			$logger.info("Dentures landing page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["top-pages"]["dentures"]
			header.dropdown(2).click
			wait.until { $test_driver.title.include? title }

			#Billboard
			tc.billboard
			#Breadcrumbs
			tc.test_breadcrumbs("dentures",nil,"Dentures")
			#Test page links
			test_link_back(dentures.compare_dentures_cta,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.money_back1_link,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(dentures.denture_lab_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.money_back2_link,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(dentures.warranty_link,title,parsed["dentures"]["denture-warranties"])
			test_link_back(dentures.denture_style_link,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.view_details_cta,title,parsed["top-pages"]["pricing-offers"])
			#Youtube video
			tc.test_youtube_player()

			tc.test_closest_office_details(title)
		end

		it " - Dentures made affordable page" do
			$logger.info("Dentures made affordable page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["dentures-made-affordable"]
			tc.navigate_header(2,1,title)
			wait.until { $test_driver.title.include? title }

			tc.billboard
			tc.test_breadcrumbs("dentures","dentures-made-affordable","Dentures","Dentures Made Affordable")

			test_link_back(dentures.money_back_cta,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(dentures.seven_styles_link,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.warranty_link,title,parsed["dentures"]["denture-warranties"])
			test_link_back(dentures.view_details_cta,title,parsed["top-pages"]["pricing-offers"])

			tc.test_closest_office_details(title)
		end

		it " - Denture cost page" do
			$logger.info("Denture cost page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["denture-cost"]
			tc.navigate_header(2,1,parsed["dentures"]["dentures-made-affordable"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","dentures-made-affordable","Dentures","Dentures Made Affordable")

			test_link_back(dentures.local_office_link,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.denture_offer,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.click_here_link,title,parsed["office"]["insurance-financing"])

			tc.test_closest_office_details(title)
		end

		it " - Denture warranties page" do
			$logger.info("Denture warranties page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["denture-warranties"]
			tc.navigate_header(2,1,parsed["dentures"]["dentures-made-affordable"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(2).displayed? }
			tcp.sidebar_sub_link(2).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","dentures-made-affordable","Dentures","Dentures Made Affordable","denture-warranties","Denture Warranties")

			test_link_back(dentures.comfilytes_link,title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.naturalytes_link,title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.flexilytes_link,title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.flexilytes_combo_link,title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.classic_full_link,title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.basic_full_link,title,parsed["dentures"]["basic-full"])
			test_link_back(dentures.cast_partial_link,title,parsed["dentures"]["cast-partial"])

			tc.test_closest_office_details(title)
		end

		it " - Compare dentures page" do
			$logger.info("Compare dentures page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["types-of-dentures"]
			tc.navigate_header(2,2,title)
			wait.until { $test_driver.title.include? title }
			tc.test_breadcrumbs("dentures","compare-dentures","Dentures","Compare Dentures")

			test_link_back(dentures.denture_offer2,title,parsed["office"]["pricing-offers"])
			# Full Dentures
			test_link_back(dentures.comfilytes_link,title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.naturalytes_link,title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.classic_full_link,title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.basic_full_link,title,parsed["dentures"]["basic-full"])
			#Images
			test_link_back(dentures.full_denture_image_link(1),title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.full_denture_image_link(2),title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.full_denture_image_link(3),title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.full_denture_image_link(4),title,parsed["dentures"]["basic-full"])

			test_link_back(dentures.office_details_links[0],title,parsed["office"]["pricing-offers"])

			#Partial Dentures
			test_link_back(dentures.flexilytes_combo_link,title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.flexilytes_link,title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.cast_partial_link,title,parsed["dentures"]["cast-partial"])
			#Images
			test_link_back(dentures.partial_denture_image_link(1),title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.partial_denture_image_link(2),title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.partial_denture_image_link(3),title,parsed["dentures"]["cast-partial"])

			test_link_back(dentures.office_details_links[1],title,parsed["office"]["pricing-offers"])

			tc.test_closest_office_details(title)

			# Anchors
			js_scroll_up(dentures.full_dentures_anchor,true)
			dentures.full_dentures_anchor.click
			wait.until { dentures.full_dentures_container.displayed? }
			js_scroll_up(dentures.partial_dentures_anchor,true)
			dentures.partial_dentures_anchor.click
			wait.until { dentures.partial_dentures_container.displayed? }
		end


		it " - Denture quality page" do
			$logger.info("Denture quality page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["custom-dentures"]
			tc.navigate_header(2,3,title)
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","denture-quality","Dentures","Denture Quality")

			test_link_back(dentures.basic_link,title,parsed["dentures"]["basic-full"])
			test_link_back(dentures.classic_link,title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.naturalytes_link2,title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.comfilytes_link2,title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.flexilytes_combo_link2,title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.flexilytes_link2,title,parsed["dentures"]["flexilytes"])
			
			tc.test_closest_office_details(title)
		end

		it " - Parital dentures page" do
			$logger.info("Parital dentures page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["partial-dentures"]
			tc.navigate_header(2,4,title)
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial & Flexible Dentures")
			
			tc.test_closest_office_details(title)
		end

		it " - Cast partial page" do
			$logger.info("Cast partial page")
			forsee.add_cookies()
			parsed = JSON.parse(open("spec/page_titles.json").read)
			title = parsed["dentures"]["cast-partial"]
			tc.navigate_header(2,4,parsed["dentures"]["partial-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial Dentures","cast-partial","Cast Partial")

			test_carousel(dentures)
			
			tc.test_closest_office_details(title)
		end
	end
end