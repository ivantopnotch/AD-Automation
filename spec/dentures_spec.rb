require 'spec_helper'
require 'two_column_spec'

def test_carousel()
	# wait = Selenium::WebDriver::Wait.new(timeout: 5)
	# dentures = DenturesPage.new()
	
	# #Verify carousel is displayed
	# wait.until { dentures.slide(2).displayed? }
	# #Verify dynamic state of carousel
	# expect(dentures.slide(2).attribute("class").include? "slick-current").to eql true
	# wait.until { dentures.slide(3).attribute("class").include? "slick-current" }

	# #Click next five times
	# for i in 1 .. 5
	# 	dentures.next_arrow_cta.click
	# 	sleep 0.5
	# end
	# expect(dentures.slide(3).attribute("class").include? "slick-current").to eql true

	# #Click back five times
	# for i in 1 .. 5
	# 	dentures.prev_arrow_cta.click
	# 	sleep 0.5
	# end
	# expect(dentures.slide(2).attribute("class").include? "slick-current").to eql true

	# #Check all meatballs
	# for i in 4 .. 1
	# 	dentures.meatball(i).click
	# 	#Slide indexes are offset by one to meatball
	# 	expect(dentures.slide(i+1).attribute("class").include? "slick-current").to eql true
	# 	sleep 0.5
	# end
end

describe "Dentures pages functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new() 
	tcp = TwoColumnPage.new()
	dentures = DenturesPage.new()
	scroll_sleep_time = 3
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	parsed = JSON.parse(open("spec/page_titles.json").read)

	describe " - User can read dentures pages correctly" do
		$logger.info("User can read dentures pages correctly")

		it " - Sidebar" do
			$logger.info("Sidebar")
			#Click oral health link on header
			header.dropdown(2).click
			#Load and modify page titles from json
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

			sub_titles4 = [parsed["dentures"]["when-to-get-dentures"],parsed["dentures"]["denture-facts-myths"],parsed["dentures"]["how-to-clean-dentures"]]
			parsed["dentures"].delete("when-to-get-dentures")
			parsed["dentures"].delete("denture-facts-myths")
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
			#Verify elements
			expect(dentures.talk_about_dentures.displayed?).to eql true
			expect(dentures.money_back_guarantee.displayed?).to eql true
			expect(dentures.dentures_at_a_glance.displayed?).to eql true
			expect(dentures.promotional_callout.displayed?).to eql true
			#Test page links
			test_link_back(dentures.compare_dentures_cta,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.money_back1_link,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			if(ENV['BROWSER_TYPE'] != 'FIREFOX') #can't get firefox to click this one
				test_link_back(dentures.denture_lab_link,title,parsed["dentures"]["dentures-made-affordable"])
			end
			test_link_back(dentures.money_back2_link,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(dentures.warranty_link,title,parsed["dentures"]["denture-warranties"])
			test_link_back(dentures.denture_style_link,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.view_details_cta,title,parsed["top-pages"]["pricing-offers"])
			#Youtube video
			tc.test_youtube_player()
			expect(dentures.ada_image.displayed?).to eql true

			tc.test_closest_office_details(title)
		end

		it " - Dentures made affordable page" do
			$logger.info("Dentures made affordable page")
			forsee.add_cookies()
			
			title = parsed["dentures"]["dentures-made-affordable"]
			tc.navigate_header(2,1,title)
			wait.until { $test_driver.title.include? title }

			tc.billboard
			tc.test_breadcrumbs("dentures","dentures-made-affordable","Dentures","Dentures Made Affordable")

			expect(dentures.promotional_callout.displayed?).to eql true

			test_link_back(dentures.money_back_cta,title,parsed["what-to-expect"]["peace-of-mind-promise"])
			test_link_back(dentures.seven_styles_link,title,parsed["dentures"]["types-of-dentures"])
			test_link_back(dentures.warranty_link,title,parsed["dentures"]["denture-warranties"])
			test_link_back(dentures.view_details_cta,title,parsed["top-pages"]["pricing-offers"])

			tc.test_closest_office_details(title)
		end

		it " - Denture cost page" do
			$logger.info("Denture cost page")
			forsee.add_cookies()

			title = parsed["dentures"]["denture-cost"]
			tc.navigate_header(2,1,parsed["dentures"]["dentures-made-affordable"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","dentures-made-affordable","Dentures","Dentures Made Affordable")

			test_link_back(dentures.local_office_link,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.denture_offer,title,parsed["office"]["pricing-offers"])
			if(ENV['BROWSER_TYPE'] != 'FIREFOX')
				test_link_back(dentures.click_here_link,title,parsed["office"]["insurance-financing"])
			end

			tc.test_closest_office_details(title)
		end

		it " - Denture warranties page" do
			$logger.info("Denture warranties page")
			forsee.add_cookies()

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
			#Other rows
			expect(dentures.appearance_rows[0].displayed?).to eql true
			expect(dentures.material_rows[0].displayed?).to eql true
			expect(dentures.warranty_rows[0].displayed?).to eql true

			test_link_back(dentures.office_details_links[0],title,parsed["office"]["pricing-offers"])

			#Partial Dentures
			test_link_back(dentures.flexilytes_combo_link,title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.flexilytes_link,title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.cast_partial_link,title,parsed["dentures"]["cast-partial"])
			#Images
			test_link_back(dentures.partial_denture_image_link(1),title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.partial_denture_image_link(2),title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.partial_denture_image_link(3),title,parsed["dentures"]["cast-partial"])
			#Other rows
			expect(dentures.appearance_rows[1].displayed?).to eql true
			expect(dentures.material_rows[1].displayed?).to eql true
			expect(dentures.warranty_rows[1].displayed?).to eql true

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

			title = parsed["dentures"]["custom-dentures"]
			tc.navigate_header(2,3,title)
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","denture-quality","Dentures","Denture Quality")

			test_link_back(dentures.basic_link,title,parsed["dentures"]["basic-full"])
			test_link_back(dentures.classic_link,title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.naturalytes_link2,title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.comfilytes_link2,title,parsed["dentures"]["comfilytes"])
			if(ENV['BROWSER_TYPE'] != 'FIREFOX')
				test_link_back(dentures.flexilytes_combo_link2,title,parsed["dentures"]["flexilytes-combo"])
			end
			test_link_back(dentures.flexilytes_link2,title,parsed["dentures"]["flexilytes"])
			
			tc.test_closest_office_details(title)
		end

		it " - Parital dentures page" do
			$logger.info("Parital dentures page")
			forsee.add_cookies()

			title = parsed["dentures"]["partial-dentures"]
			tc.navigate_header(2,4,title)
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial & Flexible Dentures")
			
			tc.test_closest_office_details(title)
		end

		it " - Cast partial page" do
			$logger.info("Cast partial page")
			forsee.add_cookies()

			title = parsed["dentures"]["cast-partial"]
			tc.navigate_header(2,4,parsed["dentures"]["partial-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial Dentures","cast-partial","Cast Partial")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.six_month_warranty_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Flexilytes page" do
			$logger.info("Flexilytes page")
			forsee.add_cookies()

			title = parsed["dentures"]["flexilytes"]
			tc.navigate_header(2,4,parsed["dentures"]["partial-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(2).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial Dentures","flexilytes","Flexilytes")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.two_year_warranty_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Flexilytes Combo page" do
			$logger.info("Flexilytes Combo page")
			forsee.add_cookies()

			title = parsed["dentures"]["flexilytes-combo"]
			tc.navigate_header(2,4,parsed["dentures"]["partial-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(3).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","partial-dentures","Dentures","Partial Dentures","flexilytes-combo","Flexilytes Combo")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.two_year_warranty_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Full dentures page" do
			$logger.info("Full dentures page")
			forsee.add_cookies()

			title = parsed["dentures"]["full-dentures"]
			tc.navigate_header(2,5,title)
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","full-dentures","Dentures","Full Dentures")
			
			tc.test_closest_office_details(title)
		end

		it " - Basic Full page" do
			$logger.info("Basic Full page")
			forsee.add_cookies()

			title = parsed["dentures"]["basic-full"]
			tc.navigate_header(2,5,parsed["dentures"]["full-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","full-dentures","Dentures","Full Dentures","basic-full","Basic Full")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.six_month_warranty_short_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Classic Full page" do
			$logger.info("Classic Full page")
			forsee.add_cookies()

			title = parsed["dentures"]["classic-full"]
			tc.navigate_header(2,5,parsed["dentures"]["full-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(2).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","full-dentures","Dentures","Full Dentures","classic-full","Classic Full")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.one_year_warranty_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Naturalytes page" do
			$logger.info("Naturalytes page")
			forsee.add_cookies()

			title = parsed["dentures"]["naturalytes"]
			tc.navigate_header(2,5,parsed["dentures"]["full-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(3).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","full-dentures","Dentures","Full Dentures","naturalytes","Naturalytes")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.three_year_warranty_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - Comfilytes page" do
			$logger.info("Comfilytes page")
			forsee.add_cookies()

			title = parsed["dentures"]["comfilytes"]
			tc.navigate_header(2,5,parsed["dentures"]["full-dentures"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(4).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","full-dentures","Dentures","Full Dentures","comfilytes","Comfilytes")

			test_carousel()

			test_link_back(dentures.money_back2_link,title,parsed["dentures"]["dentures-made-affordable"])
			test_link_back(dentures.denture_promo2,title,parsed["office"]["pricing-offers"])
			test_link_back(dentures.seven_year_warranty_link,title,parsed["dentures"]["denture-warranties"])
			test_link_back(dentures.seven_year_warranty_short_link,title,parsed["dentures"]["denture-warranties"])
			
			tc.test_closest_office_details(title)
		end

		it " - SecureDent page" do
			$logger.info("SecureDent page")
			forsee.add_cookies()

			title = parsed["dentures"]["securedent"]
			tc.navigate_header(2,6,title)

			tc.test_breadcrumbs("dentures","securedent-implant-system","Dentures","Securedent Implant System")
			
			tc.test_closest_office_details(title)
		end

		it " - Denture Repair Reline page" do
			$logger.info("Denture Repair Reline page")
			forsee.add_cookies()

			title = parsed["dentures"]["denture-repair-reline"]
			tc.navigate_header(2,7,title)

			tc.test_breadcrumbs("dentures","denture-repair-reline","Dentures","Denture Repair Reline")

			test_link_back(dentures.denture_promo3,title,parsed["office"]["pricing-offers"])
			
			tc.test_closest_office_details(title)
		end

		it " - Denture Advice page" do
			$logger.info("Denture Advice page")
			forsee.add_cookies()

			title = parsed["dentures"]["denture-advice"]
			tc.navigate_header(2,8,title)

			tc.test_breadcrumbs("dentures","denture-advice","Dentures","Denture Advice")

			test_link_back(dentures.here_link,title,parsed["dentures"]["how-to-clean-dentures"])
			test_link_back(dentures.contact_link,title,parsed["top-pages"]["FAO"])
			test_link_back(dentures.adjustments_link,title,parsed["dentures"]["denture-repair-reline"])
			
			tc.test_closest_office_details(title)
		end

		it " - When to Get Dentures page" do
			$logger.info("When to Get Dentures page")
			forsee.add_cookies()

			title = parsed["dentures"]["when-to-get-dentures"]
			tc.navigate_header(2,8,parsed["dentures"]["denture-advice"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(1).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","denture-advice","Dentures","Denture Advice","when-to-get-dentures","When To Get Dentures")

			test_link_back(dentures.schedule_link,title,parsed["top-pages"]["SAA"])
			test_link_back(dentures.contact_dentist_link,title,parsed["top-pages"]["FAO"])
			test_link_back(dentures.here_link,title,parsed["dentures"]["custom-dentures"])

			expect(dentures.promotional_callout.displayed?).to eql true
			test_link_back(dentures.view_details_cta,title,parsed["office"]["pricing-offers"])
			
			tc.test_closest_office_details(title)
		end

		it " - Denture Facts & Myths page" do
			$logger.info("Denture Facts & Myths page")
			forsee.add_cookies()

			title = parsed["dentures"]["denture-facts-myths"]
			tc.navigate_header(2,8,parsed["dentures"]["denture-advice"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(2).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","denture-advice","Dentures","Denture Advice","denture-myths-facts","Denture Myths Facts")
			
			tc.test_closest_office_details(title)
		end

		it " - How to Clean Dentures page" do
			$logger.info("How to Clean Dentures page")
			forsee.add_cookies()

			title = parsed["dentures"]["how-to-clean-dentures"]
			tc.navigate_header(2,8,parsed["dentures"]["denture-advice"])
			#Click sidebar sub-link
			wait.until { tcp.sidebar_sub_link(1).displayed? }
			tcp.sidebar_sub_link(3).click
			wait.until { $test_driver.title.include? title }

			tc.test_breadcrumbs("dentures","denture-advice","Dentures","Denture Advice","how-to-clean-dentures","How To Clean Dentures")
			
			tc.test_closest_office_details(title)
		end

	end
end