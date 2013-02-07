# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.find_or_create_by_email! 'sanojimaru@gmail.com', password: '1qazxsw23edcvfr4'

ero_sites = [
  {
    name: 'ピンクちゃんねる',
    domain: 'http://www.pinkchannnel.com/',
    rss: 'http://www.pinkchannnel.com/index.rdf',
    title_css: 'body #main .article-header h2',
    img_css: 'body #main .article-body-inner a > img.pict',

  },
  {
    name: "ぼっき速報",
    domain: 'http://bokkisokuho.ldblog.jp/',
    rss: 'http://bokkisokuho.ldblog.jp/index.rdf',
    title_css: 'body #main .article-header h2',
    img_css: 'body #main .article-body-inner a > img.pict',
  },
  {
    name: "みんくチャンネル",
    domain: 'http://minkch.com/',
    rss: 'http://minkch.com/index.rdf',
    title_css: 'body #main .article-header h2',
    title_css: 'body #main .article-header h2',
    img_css: 'body #main .article-body-inner a > img.pict',
  },
  {
    name: "おっき速報",
    domain: 'http://okkisokuho.blog107.fc2.com/',
    rss: 'http://okkisokuho.blog107.fc2.com/?xml',
    title_css: 'body .main_cont > .entry_box > h2.entry_title',
    img_css: 'body .main_cont > .entry_box > .entry_text > a > img',
  },
  {
    name: 'フェチ速',
    domain: 'http://hitorihnoyoru.blog104.fc2.com/',
    rss: 'http://hitorihnoyoru.blog104.fc2.com/?xml',
    title_css: 'body .main_cont > .entry_box > h2.entry_title',
    title_css: 'body .main_cont > .entry_box > h2.entry_title',
    img_css: 'body .main_cont > .entry_box > .entry_text > a > img',
  },
]

ero_sites.each do |ero_site|
  site = Site.find_or_initialize_by_domain ero_site[:domain], ero_site
  site.save!
end
