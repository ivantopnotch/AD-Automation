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
    return $test_driver.find_element(:class, "nav-cta-description").find_element(:xpath, "//ul[@id='cta-nav']/li[@class='nav-item account-menu']/a[@class='nav-cta-description']")
  end

  #Dropdowns and their links
  def dropdown(number)
    return $test_driver.find_element(:xpath, "//nav[@id='site-nav-wrapper']/ul[@class='site-nav']/li[@class='nav-item-wrapper']["+number.to_s+"]")
  end

  def dropdown_link(drop_no, link_no)
    return $test_driver.find_element(:xpath, "//nav[@id='site-nav-wrapper']/ul[@class='site-nav']/li[@class='nav-item-wrapper']["+drop_no.to_s+"]/ul//li["+link_no.to_s+"]/a")
  end

  #My account dropdown stuff
  def view_account_cta()
    return $test_driver.find_element(:xpath => "//div[@class='account-dropdown logged']/a[@class='button']")
  end

  def log_out_link()
    return $test_driver.find_element(:xpath => "//div[@class='account-dropdown logged']/a[@class='logout']")
  end

  def sign_in_cta()
    return $test_driver.find_element(:xpath => "//div[@class='account-dropdown']/a[@class='button']")
  end

  def sign_up_link()
    return $test_driver.find_element(:xpath => "//div[@class='account-dropdown']/a[2]")
  end

  #Search page stuff
  def search_form()
    return $test_driver.find_element(:id, "search-field") #id is serach field, but is actually the <form> tag
  end

  def search_field()
    return $test_driver.find_element(:xpath => "//form[@id='search-field']/input[@class='text-field']")
  end

  def search_keyword()
    return $test_driver.find_element(:class, "search-keyword")
  end

  def search_results()
    return $test_driver.find_elements(:xpath => "//div[@class='search-options padded-vertical']/div[@class='content-box']/a")
  end

end
