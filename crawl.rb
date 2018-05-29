require 'selenium-webdriver'
require "nokogiri"
require "open-uri"
require "active_record"
require './common'
require './db'
require './html'
require './list_url'


class Crawl
	class << self
		def run
	    Category.where(is_get: 0).each do |category|
	    	html = Html.new
	    	doc = html.build_doc(category.url)
	    	item_detail(doc, category,html)
	    	category.is_get = 1
	    	category.save
  	  end
  	end

  	private

  	def item_detail(doc, category, html)
  		doc.css('.items-box').each do |box|
  			next if Item.where(url: box.css('a').first[:href]).exists?

  			item = Item.new
  			item.name = box.css('.items-box-name').inner_text.strip
  			item.url = box.css('a').first[:href]
  			item.category_id = category.id
  			item.price = box.css('.items-box-price').inner_text.delete("^0-9")
  			item.tax = box.css('.item-box-tax').inner_text.strip
  			if box.css('.items-box-likes').length > 0
					item.like = box.css('.items-box-likes').inner_text.delete("^0-9")
				end
  			if box.css('.item-sold-out-badge').length > 0
  				item.is_sold = 1
  			end
  			item.photo_url = doc.css('.items-box').css('img').first[:src].sub!(/\?.*/m, "")
  			item.save
  			# saved_photo(item.id, doc.css('.items-box').css('img').first[:src])
  		end

			unless doc.css('.pager-next').empty?
				url = 'https://www.mercari.com' + doc.css('.pager-next').css('.pager-cell').first.css('a')[0][:href]
				html.quit

  			html = Html.new
  			sleep(2)
  			item_detail(html.build_doc(url), category, html)
			end
			# html.quit
  	end

		def saved_photo(item_id, photo_url)
			sleep(2)

			saved_path = "photos/#{item_id.to_s}"
			FileUtils.mkdir_p(saved_path) unless FileTest.exist?(saved_path)

			filename = File.basename(photo_url).sub!(/\?.*/m, "")
			open("#{saved_path}/#{filename}", 'wb') do |file|
				file.puts Net::HTTP.get_response(URI.parse(photo_url)).body
			end
		end

  end

end


Crawl.run