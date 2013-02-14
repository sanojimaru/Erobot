class Image2chesController < ApplicationController
  def index
    @images = Image2ch.scoped.limit(50)
  end
end
