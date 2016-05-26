require 'spec_helper'
require 'two_column_spec'

describe "Health Mouth Movement page functionality" do
	header = HeaderPage.new()
	forsee = ForseePage.new()
	hmm = HmmPage.new()
	tc = TwoColumnSpec.new()
	wait = Selenium::WebDriver::Wait.new(timeout: 3)
	parsed = JSON.parse(open("spec/page_titles.json").read)
	title = parsed["about"]["HMM"]


	describe "User can read Health Mouth Movement page correctly" do
		$logger.info("User can read Health Mouth Movement page correctly")

		it " - Anchor links" do
			$logger.info("Anchor links")

			#Navigate to page
			tc.navigate_header(7,5,title)

			ctas = [hmm.partnership_cta, hmm.about_cta, hmm.schedule_cta, hmm.impact_cta, hmm.gallery_cta, hmm.faq_cta]
			anchors = ["#partnership-nav","#about-nav-","#schedule-nav","#impact-nav","#gallery-nav","#faq-nav"]
			sections = [hmm.partnership_section, hmm.about_section, hmm.schedule_section, hmm.impact_section, hmm.gallery_section, hmm.faq_section]

			wait.until { ctas[0].displayed? }
			for i in 0 .. ctas.length-1
				#Verify href
				expect(ctas[i].attribute("href").include? anchors[i]).to eql true
				#Click it, and make sure intended element is visible
				js_scroll_up(ctas[i],true)
				ctas[i].click
				wait.until { sections[i].displayed? }
			end
		end

		it " - Page links" do 
			$logger.info("Page links")

			tc.navigate_header(7,5,title)

			js_scroll_up(hmm.got_your_6_link)
			test_link_tab(hmm.got_your_6_link, nil, "https://gotyour6.org/")
		end

		it " - Carousel" do
			$logger.info("Carousel")

			tc.navigate_header(7,5,title)

			#Default slide
			wait.until { hmm.slide(1).displayed? }
			expect(hmm.slide(1).attribute("class").include? "active").to eql true
			#Click next
			js_scroll_up(hmm.next)
			hmm.next.click
			expect(hmm.slide(2).attribute("class").include? "active").to eql true
			#Click previous
			js_scroll_up(hmm.prev)
			hmm.prev.click
			expect(hmm.slide(1).attribute("class").include? "active").to eql true
			#Check wrap-around
			js_scroll_up(hmm.prev)
			hmm.prev.click
			expect(hmm.slide(30).attribute("class").include? "active").to eql true
		end
	end
end