class ImagesController < ApplicationController
  def index
    @images = Image.scoped.limit(50)
    render json: @images.to_json
  end
end
