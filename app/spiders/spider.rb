# -*- coding: utf-8 -*-
require 'uri'
require 'rss'
require 'nokogiri'
require 'charlock_holmes'

class Spider
  def self.run
    Site.all.each do |site|
      rss_body = open(site.rss).read
      detection = CharlockHolmes::EncodingDetector.detect(rss_body)
      rss = Nokogiri::XML rss_body.encode('UTF-8', detection[:encoding], undef: :replace, invalid: :replace), nil, 'UTF-8'

      rss.css('item').each do |item|
        page_url = URI.parse item.attr('rdf:about')
        page_body = open(page_url).read
        detection = CharlockHolmes::EncodingDetector.detect(page_body)
        doc = Nokogiri::HTML page_body.encode('UTF-8', detection[:encoding], undef: :replace, invalid: :replace), nil, 'UTF-8'
        page_title = doc.css(site.title_css).text

        begin
          page = Page.find_or_create_by_url! page_url.to_s, site: site, title: page_title, url: page_url.to_s
        rescue => e
          puts e.class
          next
        end

        puts "*" * 20
        puts "#{page_title} : #{page_url}"

        doc.css(site.img_css).each do |img|
          link = img.parent
          param = {
            page: page,
            content: link.attr(:title),
            url: link.attr(:href),
            thumb_url: img.attr(:src),
          }

          puts param

          next unless param[:url] =~ /\.(jpg|jpeg|gif|png)$/
          begin
            Image.create! page: page, content: link.attr(:title), url: link.attr(:href), thumb_url: img.attr(:src)
          rescue => e
            puts e
            next
          end
        end
      end
    end
  end
end
