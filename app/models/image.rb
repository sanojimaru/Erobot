# -*- coding: utf-8 -*-
require 'igo-ruby'

class Image < ActiveRecord::Base
  attr_accessible :title, :url, :thumb_url, :original_url
  paginates_per 20

  default_scope lambda{ order 'images.created_at DESC' }

  def tagging
    tagger = Igo::Tagger.new Rails.root.join('vendor', 'igo', 'ipadic').to_s

    t = tagger.parse "#{self.title}"
    t.each{|m|
      puts "#{m.surface} #{m.feature}" if m.feature =~ /固有名詞/
    }
  end
end
