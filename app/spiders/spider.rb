# -*- coding: utf-8 -*-
require 'mime/types'
require 'aws/s3'
require 'RMagick'
require 'uuidtools'
require 'sanitize'

ACCESS_KEY_ID = "ACCESS_KEY_ID"
SECRET_ACCESS_KEY = "SECRET_ACCESS_KEY"
AWS_S3_BUCKET = Rails.env == 'production' ? "erobot-production" : "erobot-development"
AWS::S3::DEFAULT_HOST.replace "s3-ap-northeast-1.amazonaws.com"
AWS::S3::Base.establish_connection!(
  :access_key_id => ACCESS_KEY_ID,
  :secret_access_key => SECRET_ACCESS_KEY
)

class Spider
  def self.run
    sites = Site.all
    sites.each do |site|
      Rails.logger.debug "Start: #{site.name}"

      doc = Nokogiri::XML get(site.rss), nil, 'UTF-8'
      urls = doc.xpath('//rdf:Seq/rdf:li').map{|li| li.attr(:'rdf:resource') }

      unless urls.size > 0
        Rails.logger.error "RSS link not found: #{site.name}"
        next
      end

      urls.each do |url|
        page = Nokogiri::HTML get(url), nil, 'UTF-8'
        page_title = Sanitize.clean(page.at('title').text).gsub(site.name, '')
        images = page.css(site.img_css).reverse.map{|img| img.parent.attr(:href)}.select do |url|
          (url =~ /\.(jpg|jpeg|gif|png)$/) && !(url =~ /www.amazon.co.jp/)
        end

        if images.nil? || images.size == 0
          Rails.logger.error "Page images not found: #{page_title}(#{url})"
          next
        end

        images.each do |original_image_url|
          next if Image.exists?(:original_url => original_image_url)

          tmp_image_dir = Rails.root.join('tmp', 'images')
          FileUtils.mkdir tmp_image_dir unless File.exists?(tmp_image_dir)

          original_filename = File.basename original_image_url
          original_ext = File.extname original_filename
          tmp_image_path = File.join(tmp_image_dir, original_filename)
          tmp_thumb_path = File.join(tmp_image_dir, "thumb_#{original_filename}")

          Rails.logger.debug "Downlonad #{original_image_url} to #{tmp_image_path}"
          download original_image_url, tmp_image_path

          image = Magick::Image.read(tmp_image_path).first
          image.resize_to_fill! 640, 640
          image.write(tmp_thumb_path){|i| i.quality = 60}

          filename = "#{UUIDTools::UUID.random_create}#{original_ext}"
          thumb_filename = "thumb_#{filename}"
          uploaded_image_url = upload tmp_image_path, File.join(site.id.to_s, filename)
          uploaded_thumb_url = upload tmp_thumb_path, File.join(site.id.to_s, thumb_filename)
          FileUtils.rm tmp_image_path
          FileUtils.rm tmp_thumb_path

          begin
            Image.create!({
              title: page_title,
              url: uploaded_image_url,
              thumb_url: uploaded_thumb_url,
              original_url: original_image_url,
            })
          rescue => e
            Rails.logger.error e.message
          end

          break if Rails.env == 'development'
        end

        break if Rails.env == 'development'
      end
    end
  end

  def self.fetch url, limit = 10
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    uri = URI.parse url
    http_options = {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7',
      'Referer' => uri.to_s,
    }

    http = Net::HTTP.start(uri.host, 80)
    response = http.get "#{uri.path}?#{uri.query}", http_options
    case response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else response
    end
  end

  def self.get url, encode_utf8 = true
    body = fetch(url).body

    if encode_utf8
      detection = CharlockHolmes::EncodingDetector.detect body
      body.encode('UTF-16BE', detection[:encoding], undef: :replace, invalid: :replace).encode('UTF-8')
    else
      body
    end
  end

  def self.download src, dest
    open(dest, 'wb') do |file|
      file.puts get(src, false)
    end
  end

  def self.upload src, dest
    mime_type = MIME::Types.type_for(src).first.to_s
    AWS::S3::S3Object.store(
      dest,
      File.open(src),
      AWS_S3_BUCKET,
      :content_type => mime_type,
      :access => :public_read
    )

    "http://#{AWS::S3::DEFAULT_HOST}/#{AWS_S3_BUCKET}/#{dest}"
  end
end
