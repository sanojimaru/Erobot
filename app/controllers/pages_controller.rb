class PagesController < ApplicationController
  def index
    @pages = Page.scoped.page params[:page]
  end
end
