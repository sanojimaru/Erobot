class Page < ActiveRecord::Base
  attr_accessible :site, :title, :url

  belongs_to :site
  has_many :images

  validates :url, presence: true
end
