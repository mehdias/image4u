class ImagesController < ApplicationController
  def index

  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.create(image_params)
    if @image.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:image).permit(:message)
  end

end
