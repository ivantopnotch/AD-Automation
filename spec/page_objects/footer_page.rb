class FooterPage

    def initialize()
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
        @scroll_sleep_time = 3
    end

    #Social media links
    def blog_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Blog")
    end

    def youtube_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Youtube")
    end

    def facebook_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Facebook")
    end

    def twitter_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Twitter")
    end

    def patient_forms_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Patient Forms")
    end

    def dental_services_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][1]/nav/h2[@class='heading']/a")
    end

    def dentures_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][2]/nav/h2[@class='heading']/a")
    end

    def pricing_and_offers_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][3]/nav/h2[@class='heading'][1]/a")
    end

    def patient_reviews_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][3]/nav/h2[@class='heading'][2]/a")
    end

    def what_to_expect_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][3]/nav/h2[@class='heading'][3]/a")
    end

    def patient_forms_cat_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][4]/div/nav/span[@class='heading'][1]/a[@class='download-patient-forms']")
    end

    def oral_health_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][4]/div/nav/span[@class='heading'][2]/a")
    end

    def about_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][4]/nav/h2[@class='heading'][1]/a")
    end

    def faq_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][4]/nav/h2[@class='heading'][2]/a")
    end

    def my_account_link()
        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2'][4]/nav/h2[@class='heading'][3]/a")
    end

    #Categorized links
    def categorized_link(cat_no, link_no)
        #Extra div in fourth column
        extra_div = ""
        if cat_no == 4
            extra_div = "/div"
        end

        return $test_driver.find_element(:id, "footer").find_element(:xpath => "//div[@class='container direct-container']/div[@class='links grid-whole']/div[@class='footer-section grid-2']["+cat_no.to_s+"]"+extra_div+"/nav/ul/li["+link_no.to_s+"]/a")
    end

    def contact_us_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Contact Us")
    end

    def job_site_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Visit our job site")
    end

    def sign_up_cta()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Sign Up")
    end

    def privacy_policy_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Privacy Policy")
    end

    def terms_of_use_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Terms of Use")
    end

    def site_map_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Site Map")
    end

    def office_listings_link()
        return $test_driver.find_element(:id, "footer").find_element(:partial_link_text, "Dental Office Listings")
    end
end