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
    name: 'ぴんくちゃんねる～エロ画像・アダルト画像まとめ～',
    domain: 'http://www.pinkchannnel.com/',
    rss: 'http://www.pinkchannnel.com/index.rdf',
    title_css: '#main .article-header h2',
    img_css: '#main .article-body-inner a > img.pict',

  },
  {
    name: "ぼっき速報三次エロ画像とエロ動画",
    domain: 'http://bokkisokuho.ldblog.jp/',
    rss: 'http://bokkisokuho.ldblog.jp/index.rdf',
    title_css: '#container .article .entry-title',
    img_css: '#container .article .article-body-more a img.pict',
  },
  {
    name: "みんくちゃんねる",
    domain: 'http://minkch.com/',
    rss: 'http://minkch.com/index.rdf',
    title_css: 'body #main .article-header h2',
    img_css: 'body #main .article-body-inner a > img.pict',
  },
  {
    name: "エロ画像まとめ　おっき速報",
    domain: 'http://okkisokuho.blog107.fc2.com/',
    rss: 'http://okkisokuho.blog107.fc2.com/?xml',
    title_css: 'body .main_cont > .entry_box > h2.entry_title',
    img_css: 'body .main_cont > .entry_box > .entry_text > a > img',
  },
  {
    name: 'フェチ速～2ch・2ちゃんねるのエロ画像、アダルト画像まとめ～',
    domain: 'http://hitorihnoyoru.blog104.fc2.com/',
    rss: 'http://hitorihnoyoru.blog104.fc2.com/?xml',
    title_css: '#center .ently_outline > h2',
    img_css: '#center .ently_outline .ently_body .ently_text a > img.pict',
  },
]

ero_sites.each do |ero_site|
  site = Site.find_or_create_by_domain! ero_site[:domain], ero_site
  site.update_attributes! ero_site
end
