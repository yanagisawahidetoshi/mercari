require 'open-uri'
require 'fileutils'
require 'net/http'
require './db'

class Photo
  class << self
    def run
      items = Item
        .select('id, photo_url, is_get_photo')
        .where(is_get_photo: 0)
        .where.not(photo_url: nil)

      items.each do |item|
        savedPhoto(item)
        sleep(2)
      end
    end

    def savedPhoto(item)
      saved_path = "photos/#{item.id.to_s}"
      FileUtils.mkdir_p(saved_path) unless FileTest.exist?(saved_path)

      filename = File.basename(item.photo_url)
      open("#{saved_path}/#{filename}", 'wb') do |file|
        file.puts Net::HTTP.get_response(URI.parse(item.photo_url)).body
      end
      item.is_get_photo = 1
      item.save
    end
  end
end

Photo.run