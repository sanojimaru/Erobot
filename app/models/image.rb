class Image < ActiveRecord::Base
  attr_accessible :text_title, :text_content, :url, :thumb_url, :original_url
  paginates_per 20

  default_scope lambda{ order 'images.created_at DESC' }
end
