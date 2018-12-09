class ImagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
 

  def new
    @image = Image.new
  end

  def show
    @image = Image.find_by_id(params[:id])
    return render_not_found if @image.blank?
  end
  
  def edit
    @image = Image.find_by_id(params[:id])
    return render_not_found if @image.blank?
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
  def update
    @image = Image.find_by_id(params[:id])
      return render_not_found if @image.blank?
    @image.update_attributes(image_params)
      if @image.valid?    
        redirect_to root_path
      else
        return render :edit, status: :unprocessable_entity
      end
  end
  def destroy
    @image = Image.find_by_id(params[:id])
     return render_not_found if @image.blank?
     @image.destroy
     redirect_to root_path
  end



  private

  def image_params
    params.require(:image).permit(:message)
  end

  def render_not_found
    render plain: 'Not Found :(', status: :not_found
  end

end
