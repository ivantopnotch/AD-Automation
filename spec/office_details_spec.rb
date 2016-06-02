require 'spec_helper'
require 'two_column_spec'
require 'net/http'

def verify_billboard()
	offdet = OfficeDetailsPage.new()

	expect(offdet.office_address.displayed?).to eql true
	expect(offdet.phone_number.displayed?).to eql true
	expect(offdet.owned_and_operated.displayed?).to eql true
end

describe "Office details functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	tc = TwoColumnSpec.new()
	offdet = OfficeDetailsPage.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	parsed = JSON.parse(open("spec/page_titles.json").read)

	#Office used for testing
	office_name = "Oswego"
	office_state = "NY"
	office_slug = "oswego-ny-13126-3298"

	describe "User can use office details pages correctly" do
		$logger.info("User can use office details pages correctly")

		it " - Billboard" do
			$logger.info("Billboard")
		 	forsee.add_cookies()
			title = parsed["office"]["about-office"]

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until{ offdet.breadcrumbs.displayed? }
			tc.test_breadcrumbs(office_slug, nil, "Dentist " + office_name + " " + office_state)

			#Verify elements
			wait.until { offdet.billboard_bar.displayed? }
			expect(offdet.office_address.displayed?).to eql true
			expect(offdet.phone_number.displayed?).to eql true
			expect(offdet.owned_and_operated.displayed?).to eql true
			#Show/hide office hours
			num_retry = 0
			begin
				expect(offdet.office_hours_link.displayed?).to eql true
				offdet.office_hours_link.click
				wait.until { offdet.office_hours.attribute("class").include? "shown" }
			rescue Selenium::WebDriver::Error::NoSuchElementError
				retry if (num_retry += 1) == 1
			end
			#Verify links
			test_link_tab(offdet.get_directions_link, nil, "https://www.google.com/maps")
			test_link_back(offdet.find_an_office, title, parsed["top-pages"]["FAO"])
			check_http_status(offdet.other_offices.attribute("href"))
			test_link_back(offdet.schedule_cta, title, parsed["top-pages"]["SAA"])
		end

		it " - About This Office page" do
			$logger.info("About This Office page")
		    forsee.add_cookies()
			title = parsed["office"]["about-office"]

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until{ offdet.breadcrumbs.displayed? }
			tc.test_breadcrumbs(office_slug, nil, "Dentist " + office_name + " " + office_state)

			expect(offdet.office_picture.displayed?).to eql true
			expect(offdet.office_text.displayed?).to eql true
			expect(offdet.dentist_list.displayed?).to eql true
			expect(offdet.service_list.displayed?).to eql true

			#Verify tooltips
			offdet.green_tooltips.each do |tooltip|
				js_scroll_up(tooltip)
				tooltip.click
				wait.until { offdet.shadowbox.displayed? }
			end

			#Verify shadowbox closing
			for i in 0 .. 1
				num_retry = 0
				begin
					offdet.green_tooltips[0].click
					wait.until { offdet.shadowbox.displayed? }
					if i == 0
						#Click X
						js_scroll_up(offdet.shadowbox_close_cta)
						offdet.shadowbox_close_cta.click
					else
						#Click outside shadowbox
						offdet.service_list.click
					end
					wait_for_disappear(offdet.shadowbox)
				rescue Selenium::WebDriver::Error::NoSuchElementError
					retry if (num_retry += 1) == 1
				end
			end
		end

		it " - Pricing & Offers - Anchors and general dentistry" do
			$logger.info("Pricing & Offers - Anchors and general dentistry")
			forsee.add_cookies()
			title = parsed["office"]["pricing-offers"]

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until{ offdet.breadcrumbs.displayed? }

			#Click sidebar link
			offdet.sidebar_link(1).click
			wait.until { $test_driver.title.include? title }
			#Check for triangle
			expect(offdet.sidebar_link(1).attribute("class").include? "selected").to eql true

			verify_billboard()

			#Verify anchor links
			anchors = [offdet.general_dentistry, offdet.full_dentures, offdet.partial_dentures, offdet.special_offers, offdet.payment_policy, offdet.refund_policy, offdet.request_a_refund]
			for i in 0 .. offdet.anchor_links.length-1
				js_scroll_up(offdet.anchor_links[i],true)
				offdet.anchor_links[i].click
				wait.until { anchors[i].displayed? }
			end
			# Return to the top links
			offdet.return_to_top_links.each do |link|
				js_scroll_up(link,true)
				link.click
				wait.until { offdet.general_dentistry.displayed? } #Check using this one because it's at the top
			end

			#General dentistry
			#Offer banner
			#expect(offdet.general_dentistry_offer.displayed?).to eql true

			#General dentistry price list
			expect(offdet.general_dentistry_list.displayed?).to eql true
			offdet.green_tooltips.each do |tooltip|
				js_scroll_up(tooltip,true)
				tooltip.click
				wait.until { offdet.shadowbox.displayed? }
			end
		end


		it " - Pricing & Offers - The rest" do
			$logger.info("Pricing & Offers page - The rest")
			forsee.add_cookies()
			title = parsed["office"]["pricing-offers"]

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until{ offdet.breadcrumbs.displayed? }

			#Click sidebar link
			offdet.sidebar_link(1).click
			wait.until { $test_driver.title.include? title }

			#Denture comparison chart link
			test_link_back(offdet.denture_comp_chart_links[0],title,parsed["office"]["dentures-partials"])

			#Expand denture tables
			wait.until { offdet.full_dentures_table.displayed? }
			tables = [offdet.full_dentures_table, offdet.partial_dentures_table]
			for i in 0 .. 1
				#Expand
				expect(tables[i].attribute("class").include? "collapsed").to eql true
				js_scroll_up(offdet.see_full_links[0])
				offdet.see_full_links[0].click #Once we click, turns into collapse link
				wait.until { (tables[i].attribute("class").include? "collapsed") == false }
				#Collapse
				js_scroll_up(offdet.collapse_links[i])
				offdet.collapse_links[i].click
				wait.until { tables[i].attribute("class").include? "collapsed" }
				#Expand again for next steps
				js_scroll_up(offdet.see_full_links[0],true)
				offdet.see_full_links[0].click
			end

			#Verify all replacement cells
			for i in 0 .. 6
				expect(offdet.replacement_cells[i].displayed?)
			end

			#Verify all first-time cells
			for i in 0 .. 6
				expect(offdet.first_time_cells[i].displayed?)
			end

			#Special offers
			for i in 0 .. 1
				js_scroll_up(offdet.terms_conditions_links[i])
				offdet.terms_conditions_links[i].click
				wait.until { offdet.terms_modal.displayed? }
				offdet.modal_close.click
				sleep 1
			end

			#Verify print links
			expect(offdet.print_offer_links[0].displayed?).to eql true
			expect(offdet.print_offer_links[1].displayed?).to eql true
		end

		it " - Dentures & Partials page" do
			$logger.info("Dentures & Partials page")
			forsee.add_cookies()
			title = parsed["office"]["dentures-partials"]
			dentures = DenturesPage.new() #Page is very similar to denture comparison chart page

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until{ offdet.breadcrumbs.displayed? }

			#Click sidebar link
			offdet.sidebar_link(2).click
			wait.until { $test_driver.title.include? title }

			verify_billboard()

			# Full Dentures
			test_link_back(dentures.comfilytes_link,title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.naturalytes_link,title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.classic_full_link,title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.basic_full_link,title,parsed["dentures"]["basic-full"])
			#Images
			test_link_back(dentures.full_denture_image_link(4),title,parsed["dentures"]["comfilytes"])
			test_link_back(dentures.full_denture_image_link(3),title,parsed["dentures"]["naturalytes"])
			test_link_back(dentures.full_denture_image_link(2),title,parsed["dentures"]["classic-full"])
			test_link_back(dentures.full_denture_image_link(1),title,parsed["dentures"]["basic-full"])
			#Other rows (slightly different from dentures)
			expect(offdet.pricing_rows[0].displayed?).to eql true
			expect(offdet.appearance_rows[0].displayed?).to eql true
			expect(offdet.material_rows[0].displayed?).to eql true
			expect(offdet.warranty_rows[0].displayed?).to eql true

			#Partial Dentures
			test_link_back(dentures.flexilytes_combo_link,title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.flexilytes_link,title,parsed["dentures"]["flexilytes"])
			test_link_back(dentures.cast_partial_link,title,parsed["dentures"]["cast-partial"])
			#Images
			test_link_back(dentures.partial_denture_image_link(3),title,parsed["dentures"]["flexilytes-combo"])
			test_link_back(dentures.partial_denture_image_link(2),title,parsed["dentures"]["cast-partial"])
			test_link_back(dentures.partial_denture_image_link(1),title,parsed["dentures"]["flexilytes"])
			#Other rows
			expect(offdet.pricing_rows[1].displayed?).to eql true
			expect(offdet.appearance_rows[1].displayed?).to eql true
			expect(offdet.material_rows[1].displayed?).to eql true
			expect(offdet.warranty_rows[1].displayed?).to eql true

			#Pricing and offers links
			offdet.pricing_offers_links.each do |link|
				test_link_back(link, title, parsed["office"]["pricing-offers"])
			end

			#Verify tooltips
			offdet.green_tooltips.each do |tooltip|
				js_scroll_up(tooltip,true)
				tooltip.click
				wait.until { offdet.shadowbox.displayed? }
			end

			# Anchors
			js_scroll_up(offdet.full_anchor_link,true)
			offdet.full_anchor_link.click
			wait.until { offdet.full_dentures.displayed? }
			js_scroll_up(offdet.partial_anchor_link,true)
			offdet.partial_anchor_link.click
			wait.until { offdet.partial_dentures.displayed? }
		end

		it " - Insurance & Financing page" do
			$logger.info("Insurance & Financing page")
			forsee.add_cookies()
			title = parsed["office"]["insurance-financing"]
			dentures = DenturesPage.new() #Page is very similar to denture comparison chart page

			$test_driver.navigate.to("https://" + $ad_env + $domain + "/dentist/" + office_slug)
			wait.until { offdet.breadcrumbs.displayed? }

			#Click sidebar link
			offdet.sidebar_link(3).click
			wait.until { $test_driver.title.include? title }

			verify_billboard()

			#Logos
			for i in 0 .. 2
				expect(offdet.insurance_logos[i].displayed?).to eql true
			end

			#Verify sections
			expect(offdet.insurance_providers.displayed?).to eql true
			expect(offdet.third_party_financing.displayed?).to eql true

			#Financing tile
			num_retry = 0
			begin
				offdet.financing_tile.click
				wait.until { offdet.terms_modal.displayed? }
				offdet.modal_close.click
			rescue Selenium::WebDriver::Error::TimeOutError
				retry if (num_retry += 1) == 1
			end
		end
	end
end