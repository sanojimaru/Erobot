require 'net/http'
require 'uri'
require 'rss'
require 'nokogiri'
require 'charlock_holmes'

class Spider
  def self.run
    ero_sites = {
      'http://www.pinkchannnel.com/' => {
        rss: 'http://www.pinkchannnel.com/index.rdf',
        title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
        img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
        img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
      },
      'http://bokkisokuho.ldblog.jp/' => {
        rss: 'http://bokkisokuho.ldblog.jp/index.rdf',
        title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
        img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
        img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
      },
      'http://minkch.com/' => {
        rss: 'http://minkch.com/index.rdf',
        title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
        img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
        img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
      },
      'http://okkisokuho.blog107.fc2.com/' => {
        rss: 'http://okkisokuho.blog107.fc2.com/?xml',
        title_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/h2[@class="entry_title"]',
        img_thumb_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/div[@class="entry_text"]/a/img',
        img_link_xpath: '//div',
      },
      'http://hitorihnoyoru.blog104.fc2.com/' => {
        rss: 'http://hitorihnoyoru.blog104.fc2.com/?xml',
        title_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/h2[@class="entry_title"]',
        img_thumb_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/div[@class="entry_text"]/a/img',
        img_link_xpath: '//div',
      },
    }

    ero_sites.each do |domain, site|
      rss_body = Net::HTTP.get URI.parse(site[:rss])
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

        page_title = page.xpath(site[:title_xpath]).text
        puts page_title

        page_images = page.xpath(site[:img_link_xpath])
          .select{|link| link.attr(:href).match /.*\.(jpg|jpeg|gif|png)$/ }
          .map{|link| {url: link.attr(:href), text: link.attr(:title)}}
        puts page_images
      end
    end
  end
end
