class Site < ActiveRecord::Base
  attr_accessible :domain, :name, :rss, :title_css, :img_css
end
