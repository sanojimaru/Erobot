class Image < ActiveRecord::Base
  belongs_to :page
  attr_accessible :page, :content, :thumb_url, :url

  default_scope lambda{ order :created_at => :desc }
end
