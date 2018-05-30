require 'selenium-webdriver'
require "nokogiri"

class Html
  attr_accessor :driver
  def initialize
  end

  def build_doc(url)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.get url
    Nokogiri::HTML driver.page_source.encode("UTF-8")
  end

  def quit
  	@driver.quit()
  end
end