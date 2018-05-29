require 'selenium-webdriver'
require "nokogiri"

class Html
  attr_accessor :driver
  def initialize
  end

  def build_doc(url)
    @driver = Selenium::WebDriver.for :chrome
    @driver.get url
    Nokogiri::HTML driver.page_source.encode("UTF-8")
  end

  def quit
  	@driver.quit()
  end
end