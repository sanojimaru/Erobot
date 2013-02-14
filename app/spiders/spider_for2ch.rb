# -*- coding: utf-8 -*-
require 'uri'
require 'rss'
require 'nokogiri'
require 'charlock_holmes'
require 'fileutils'

class SpiderFor2ch
  MIMIZUN_URL = 'http://mimizun.mine.nu:81/log/2ch'

  def self.run
    downloader = Download.new
    s3uploader = S3Upload.new

    bbs_2ch = [
      {
        title: '半角文字列掲示板',
        url: 'http://kilauea.bbspink.com/ascii',
      }
    ]

    bbs_2ch.each do |bbs|
      history_url = URI "#{bbs[:url]}/kako"
      bbs_body = open(history_url).read
      encoded_body = bbs_body.encode 'UTF-8', 'CP932', undef: :replace, invalid: :replace

      html = Nokogiri::HTML encoded_body, nil, 'UTF-8'
      html.css('table tr > td > a:contains("subject.txt")').each do |atag|
        subject_url = URI "#{history_url}/#{atag.attr(:href)}"
        subject_txt = open(subject_url).read
        encoded_subject_txt = subject_txt.encode 'UTF-8', 'CP932', undef: :replace, invalid: :replace

        encoded_subject_txt.lines.each do |line|
          dat_filename, thread_title = *line.split('<>')
          dat_file_url = "#{MIMIZUN_URL}#{URI(bbs[:url]).path}/#{dat_filename}"
          puts dat_file_url
          dat_file = open(dat_file_url, 'User-Agent' => 'Monazilla/1.00 (Erobot/0.0.1)').read
          encoded_dat_file = dat_file.encode 'UTF-8', 'CP932', undef: :replace, invalid: :replace
          dat2ch = Dat2ch.find_or_create_by_url! dat_file_url, title: thread_title, url: dat_file_url, dat: encoded_dat_file rescue next

          encoded_dat_file.split(/<>|<br>/).each do |line|
            if match = URI.regexp(['http']).match(line)
              url = match.to_s
              next unless url =~ /\.(jpg|jpeg|gif|png)$/
              puts url

              tmp_image_dir = Rails.root.join('tmp', 'images')
              FileUtils.mkdir tmp_image_dir unless File.exists?(tmp_image_dir)

              tmp_image_file = downloader.get url, tmp_image_dir
              uploaded_image_url = s3uploader.put tmp_image_file, ['2ch', dat2ch.id].join('/')
              FileUtils.rm tmp_image_file

              Image2ch.create! dat2ch: dat2ch, url: uploaded_image_url, original_url: url rescue next
            end
          end
        end
      end
    end
  end
end
