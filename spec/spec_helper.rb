require 'pathname'
require 'rubygems'
require 'rest-client'
require 'json'
require 'digest'
require 'selenium-webdriver'
require 'allure-rspec'
require 'uuid'
require 'dotenv'
require 'time'
require 'date'

require_relative 'aspendental'
Dir.glob(File.join(File.dirname(__FILE__), 'page_objects/*.rb')).each { |file| require file }

RSpec.configure do |config|
  config.include AllureRSpec::Adaptor

  $logger = Logger.new('aspendental_test.txt')
  $ad_env = "uat-web"
  $domain = ".aspendental.com"

  utility = AspenDental.new()

  config.before(:each) do | x |
    test_url = "https://" + $ad_env + $domain
    $test_driver = utility.get_test_driver()

    $test_driver.manage.window.move_to(0, 0)
    $test_driver.manage.window.resize_to(ENV['BROWSER_WIDTH'], ENV['BROWSER_HEIGHT'])

    $test_driver.navigate.to(test_url)
    expect($test_driver.title.include? 'Aspen Dental').to eql true
    expect($test_driver.title.include? 'Offices Across US').to eql true
  end

  config.after(:each) do |example|

    if example.exception
      filename = "gen/"+$test_driver.current_url.gsub!(/[^0-9A-Za-z.\-]/, '-')+"-#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.png"
      example.attach_file('screenshot', File.new(
          $test_driver.save_screenshot(
              File.join(Dir.pwd, filename))))
      puts "failure screen shot - #{filename}"
    end

    if ENV['SCREENSHOT'] == 'TRUE'
      # filename = "gen/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.png"
      filename = "gen/"+$test_driver.current_url.gsub!(/[^0-9A-Za-z.\-]/, '-')+"-#{example.metadata[:description]}.png"
      example.attach_file('screenshot', File.new(
          $test_driver.save_screenshot(
              File.join(Dir.pwd, filename))))
      puts "screen shot - #{filename}"
    end


    $test_driver.quit
  end

  # config.before(:all) do
  #   time1 = Time.new
  #   puts "Start time: " + time1.inspect
  # end
  #
  # config.after(:all) do
  #   time1 = Time.new
  #   puts "End time: " + time1.inspect
  # end
end

AllureRSpec.configure do |c|
  # c.output_dir = "/whatever/you/like" # default: gen/allure-results
  # c.clean_dir = true# clean the output directory first? (default: true)
  c.logging_level = Logger::ERROR # logging level (default: DEBUG)
end

#Get current time in seconds
def time_now_sec()
	return Time.now.to_i - Date.today.to_time.to_i #Seconds since midnight
end

#Wait for an element to disappear
def wait_for_disappear(element, timeout = 5)
	start_time = time_now_sec
	begin
		while element.displayed? do
			if time_now_sec >= start_time + timeout
				fail(element.to_s + " did not disappear")
			end
		end
	rescue Selenium::WebDriver::Error::StaleElementReferenceError
		return
	rescue Selenium::WebDriver::Error::NoSuchElementError
		return
	end
end

#Prevent things from being covered by sticky header in firefox/ie
#Force = force all browsers to scroll
def js_scroll_up(element, force = false)
	if ENV['BROWSER_TYPE'] == 'FIREFOX' or ENV['BROWSER_TYPE'] == 'IE' or force
		$test_driver.execute_script("window.scrollTo(0,"+element.location.y.to_s+" - 200)")
	end
end

#Test a link and then return to page
def test_link_back(link, parent_title, expected_title, lowercase = false, timeout = 5, dont_scroll = false)
  $logger.info("Link for " + expected_title)
  wait = Selenium::WebDriver::Wait.new(timeout: timeout)

  if !dont_scroll
    js_scroll_up(link,true)
  end
  wait.until { link.displayed? }
  link.click
  begin
    if lowercase
      wait.until { $test_driver.title.downcase.include? expected_title }
    else
      wait.until { $test_driver.title.include? expected_title }
    end
  rescue Selenium::WebDriver::Error::TimeOutError
    fail("Error loading page " + expected_title)
  end
  #Go back; some browsers have problems navigating back the first time
  num_retry = 0
  begin
    $test_driver.navigate.back
    wait.until { $test_driver.title.include? parent_title }
  rescue Selenium::WebDriver::Error::TimeOutError
    num_retry += 1
    retry if num_retry == 1
    fail("Error navigating back from " + expected_title)
  end
end

#Test a link that opens a new tab/window
def test_link_tab(link, expected_title = nil, expected_url = nil)
  wait = Selenium::WebDriver::Wait.new(timeout: 3)
  
  #Open link
  link.click
  $test_driver.switch_to.window( $test_driver.window_handles.last )
  #Test it for URL or title
  begin
    if expected_title == nil
      wait.until { $test_driver.current_url.downcase.include? expected_url.downcase }
    elsif expected_url == nil
      wait.until { $test_driver.title.include? expected_title }
    else
      fail("Did not specify expected title or expected url")
    end
    #Print detalied error message
  rescue Selenium::WebDriver::Error::TimeOutError
    if expected_title == nil
      fail("Expected URL did not include " + expected_url + ", was instead: " + $test_driver.current_url)
    elsif expected_url == nil
      fail("Expected title did not include " + expected_title + ", was instead: " + $test_driver.title)
    end
  end

  #Close tab that was opened
  if ENV['BROWSER_TYPE'] == 'IE'
    $test_driver.execute_script("window.open('', '_self', ''); window.close();")
  else
    $test_driver.execute_script("window.close();")
  end
  $test_driver.switch_to.window( $test_driver.window_handles.first )
end