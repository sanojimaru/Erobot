class Image < ActiveRecord::Base
  belongs_to :page
  attr_accessible :content, :thumb_url, :url
end
