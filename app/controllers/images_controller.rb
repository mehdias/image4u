class ImagesController < ApplicationController
  def index

  end

  def new
    @image = Image.new
  end
end
