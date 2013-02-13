class Page < ActiveRecord::Base
  attr_accessible :site, :title, :url
  belongs_to :site
  has_many :images
  paginates_per 4
  validates :url, presence: true

  default_scope lambda{ includes(:images).where('images.id IS NOT NULL') }
end
