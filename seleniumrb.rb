require "selenium-webdriver"

class SeleniumRb 
	def initialize(browser)
    case browser
		when 'firefox'
      default_profile = Selenium::WebDriver::Firefox::Profile.from_name "default"
      default_profile.native_events = true
      @driver = Selenium::WebDriver.for :firefox
    when 'chrome'
      @driver = Selenium::WebDriver.for :chrome
	end
end