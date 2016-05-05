class HeaderPage

  def initialize()
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    @scroll_sleep_time = 2
  end

  def logo()
    return $test_driver.find_element(:partial_link_text, "Your mouth. Our mission.")
  end

  #Nav CTAs
  def saa_cta()
    return $test_driver.find_element(:class, "nav-cta-description").find_element(:xpath, "//a[text() = 'Schedule A New Patient Appointment']")
  end

  def fao_cta()
    return $test_driver.find_element(:class, "nav-cta-description").find_element(:xpath, "//a[contains(text(),'Find')]")
  end

  def search_cta()
    return $test_driver.find_element(:class, "nav-cta-description").find_element(:xpath, "//a[contains(text(),'Search')]")
  end

  def my_account_cta()
    return $test_driver.find_element(:class, "nav-cta-description").find_element(:xpath, "//a[text() = 'My Account']")
  end

  #Dropdowns and their links
  def dropdown(number)
    return $test_driver.find_element(:xpath, "//nav[@id='site-nav-wrapper']/ul[@class='site-nav']/li[@class='nav-item-wrapper']["+number.to_s+"]")
  end

  def dropdown_link(drop_no, link_no)
    return $test_driver.find_element(:xpath, "//nav[@id='site-nav-wrapper']/ul[@class='site-nav']/li[@class='nav-item-wrapper']["+drop_no.to_s+"]/ul//li["+link_no.to_s+"]/a")
  end

end
