class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
 


  def new
    @image = Image.new
  end

  def show
    @image = Image.find_by_id(params[:id])
    if @image.blank?
      render plain: 'Not Found :(', status: :not_found
    end
  end
  
  def index
  end

  def create
    @image = current_user.images.create(image_params)
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
