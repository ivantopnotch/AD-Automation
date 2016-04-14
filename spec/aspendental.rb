class AspenDental


  def initialize()
    # @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
  end

  def get_test_driver()

    case ENV['BROWSER_TYPE']
      when 'FIREFOX'
        #Load adblock profile
        profile = Selenium::WebDriver::Firefox::Profile.from_name "adblock2"
        profile['network.http.connection-timeout'] = 5
        Selenium::WebDriver::Firefox.path = ENV['BROWSER_LOCATION']
        return Selenium::WebDriver.for :firefox, :profile => profile
      when 'CHROME'
        Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, ENV['BROWSER_LOCATION'])
        return Selenium::WebDriver.for :chrome
      when 'SAFARI'
        return :safari
      when 'IE'
        # Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, ENV['BROWSER_LOCATION'])
        return Selenium::WebDriver.for :ie
      when 'EDGE'
        caps = Selenium::WebDriver::Remote::Capabilities.edge
        return Selenium::WebDriver.for :remote, url: "http://10.0.9.218:4444/wd/hub", desired_capabilities: caps
      else
        ENV['BROWSER_TYPE'] = 'FIREFOX'
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['network.http.connection-timeout'] = 5
        Selenium::WebDriver::Firefox.path = ENV[ENV['BROWSER_TYPE']+'_DESKTOP_BROWSER_LOCATION']
        return Selenium::WebDriver.for :firefox, :profile => profile
    end
  end

  def sanitize_filename(filename)
    returning filename.strip do |name|
      # NOTE: File.basename doesn't work right with Windows paths on Unix
      # get only the filename, not the whole path
      name.gsub!(/^.*(\\|\/)/, '')

      # Strip out the non-ascii character
      name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end


end
