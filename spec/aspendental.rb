class AspenDental


  def initialize()
    # @wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
  end

  def get_test_driver()

    case ENV['BROWSER_TYPE']
      when 'FIREFOX'
        #Load adblock profile
        profile = Selenium::WebDriver::Firefox::Profile.from_name "adblock"
        #profile = Selenium::WebDriver::Firefox::Profile.new
        profile['network.http.connection-timeout'] = 5
        profile['network.cookie.cookieBehavior'] = 0
        profile['reader.parse-on-load.enabled'] = false
        #caps = Selenium::WebDriver::Remote::Capabilities.firefox :marionette => true#, :profile => profile
        Selenium::WebDriver::Firefox.path = ENV['BROWSER_LOCATION']
        return Selenium::WebDriver.for :firefox, :profile => profile#, :desired_capabilities => caps
      when 'CHROME'
        Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, ENV['BROWSER_LOCATION'])
        caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--disable-extensions" ]})
        return Selenium::WebDriver.for :chrome, :desired_capabilities => caps
      when 'SAFARI'
        return :safari
      when 'IE'
        # Selenium::WebDriver::Chrome::Service.executable_path = File.join(Dir.pwd, ENV['BROWSER_LOCATION'])
        return Selenium::WebDriver.for :ie
      when 'EDGE'
        return Selenium::WebDriver.for :edge
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
