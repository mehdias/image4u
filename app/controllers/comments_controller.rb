class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
    def create
      @image = Image.find_by_id(params[:image_id])
      return render_not_found if @image.blank?

      @image.comments.create(comment_params.merge(user: current_user))
      redirect_to root_path
    end


    private
    def comment_params
      params.require(:comment).permit(:message)
    end

    def render_not_found(status=:not_found)
      render plain: "#{status.to_s.titleize} :(", status: status
    end

end
