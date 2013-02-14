# -*- coding: utf-8 -*-
require 'uri'
require 'rss'
require 'nokogiri'
require 'charlock_holmes'
require 'fileutils'

class Spider
  def self.run
    downloader = Download.new
    s3uploader = S3Upload.new

    Site.all.each do |site|
      begin
        rss_body = open(site.rss).read
        detection = CharlockHolmes::EncodingDetector.detect(rss_body)
        rss = Nokogiri::XML rss_body.encode('UTF-8', detection[:encoding], undef: :replace, invalid: :replace), nil, 'UTF-8'
      rescue => e
        puts e
      end

      rss.css('item').each do |item|
        begin
          page_url = URI.parse item.attr('rdf:about')
          page_body = open(page_url).read
          detection = CharlockHolmes::EncodingDetector.detect(page_body)
          doc = Nokogiri::HTML page_body.encode('UTF-8', detection[:encoding], undef: :replace, invalid: :replace), nil, 'UTF-8'
          page_title = doc.css(site.title_css).text

          page = Page.find_or_create_by_url! page_url.to_s, site: site, title: page_title, url: page_url.to_s
        rescue => e
          puts e
          next
        end

        doc.css(site.img_css).each do |img|
          begin
            link = img.parent
            param = {
              page: page,
              content: link.attr(:title),
              url: link.attr(:href),
              thumb_url: img.attr(:src),
            }

            tmp_image_dir = Rails.root.join('tmp', 'images')
            FileUtils.mkdir tmp_image_dir unless File.exists?(tmp_image_dir)

            tmp_image_file = downloader.get param[:url], tmp_image_dir
            uploaded_image_url = s3uploader.put tmp_image_file, [site.id, page.id].join('/')
            FileUtils.rm tmp_image_file

            tmp_thumb_image_file = downloader.get param[:thumb_url], tmp_image_dir
            uploaded_image_thumb_url = s3uploader.put tmp_thumb_image_file, [site.id, page.id].join('/')
            FileUtils.rm tmp_thumb_image_file

            next unless param[:url] =~ /\.(jpg|jpeg|gif|png)$/

            Image.create!({
              page: page,
              content: link.attr(:title),
              url: uploaded_image_url,
              thumb_url: uploaded_image_thumb_url,
              original_url: link.attr(:href),
              original_thumb_url: img.attr(:src)
            })
          rescue => e
            puts e
            next
          end
        end
      end
    end
  end
end
