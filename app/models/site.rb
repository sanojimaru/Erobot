class Site < ActiveRecord::Base
  attr_accessible :domain, :name, :img_link_xpath, :img_thumb_xpath, :rss, :title_xpath
end
