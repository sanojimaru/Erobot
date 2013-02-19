class ImagesController < ApplicationController
  def index
    @images = Image.scoped.page params[:page]
  end
end
