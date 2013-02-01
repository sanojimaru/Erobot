# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ero_sites = [
  {
    name: 'ピンクちゃんねる',
    domain: 'http://www.pinkchannnel.com/',
    rss: 'http://www.pinkchannnel.com/index.rdf',
    title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
    img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
    img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
  },
  {
    name: "ぼっき速報",
    domain: 'http://bokkisokuho.ldblog.jp/',
    rss: 'http://bokkisokuho.ldblog.jp/index.rdf',
    title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
    img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
    img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
  },
  {
    name: "みんくチャンネル",
    domain: 'http://minkch.com/',
    rss: 'http://minkch.com/index.rdf',
    title_xpath: '//div[@id="main"]//div[@class="article-header"]//h2',
    img_thumb_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]',
    img_link_xpath: '//div[@id="main"]//div[@class="article-body-inner"]//a/img[@class="pict"]/..',
  },
  {
    name: "おっき速報",
    domain: 'http://okkisokuho.blog107.fc2.com/',
    rss: 'http://okkisokuho.blog107.fc2.com/?xml',
    title_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/h2[@class="entry_title"]',
    img_thumb_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/div[@class="entry_text"]/a/img',
    img_link_xpath: '//div',
  },
  {
    name: 'フェチ速',
    domain: 'http://hitorihnoyoru.blog104.fc2.com/',
    rss: 'http://hitorihnoyoru.blog104.fc2.com/?xml',
    title_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/h2[@class="entry_title"]',
    img_thumb_xpath: '//div[@class="main_cont"]/div[@class="entry_box"]/div[@class="entry_text"]/a/img',
    img_link_xpath: '//div',
  },
]

ero_sites.each do |ero_site|
  site = Site.find_or_initialize_by_domain ero_site[:domain], ero_site
  site.save!
end
