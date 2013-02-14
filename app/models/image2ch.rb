class Image2ch < ActiveRecord::Base
  belongs_to :dat2ch
  attr_accessible :dat2ch, :original_url, :url

  default_scope lambda{ order('image2ches.created_at DESC') }
end
