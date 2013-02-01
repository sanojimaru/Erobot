require 'net/http'
require 'uri'
require 'rss'
require 'nokogiri'
require 'charlock_holmes'

class Spider
  def self.run
    Site.all.each do |site|
      rss_body = Net::HTTP.get URI.parse(site.rss)
      rss = nil

      begin
        rss = RSS::Parser.parse(rss_body)
      rescue RSS::InvalidRSSError
        rss = RSS::Parser.parse(rss_body, false)
      end
      next if rss.nil?

      site_title = rss.channel.title
      puts site_title

      rss.items.each do |item|
        page_url = URI.parse(item.link)
        page_body = Net::HTTP.get page_url
        page = Nokogiri::HTML.parse(page_body.force_encoding('ASCII-8BIT'))

        page_title = page.xpath(site.title_xpath).text
        puts page_title

        page_images = page.xpath(site.img_link_xpath)
          .select{|link| link.attr(:href).match /.*\.(jpg|jpeg|gif|png)$/ }
          .map{|link| {url: link.attr(:href), text: link.attr(:title)}}
        puts page_images
      end
    end
  end
end
