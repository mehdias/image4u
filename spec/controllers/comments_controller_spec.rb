require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    describe "comments#create action" do
      it "should allow users to create comments on images" do
        image = FactoryBot.create(:image)
        user = FactoryBot.create(:user)
        sign_in user
        post :create, params: {image_id: image.id, comment: { message: "awesome image"}}
        expect(response).to redirect_to root_path
        expect(image.comments.length).to eq 1
        expect(image.comments.first.message).to eq "awesome image"
      end
      it "should require a user to be logged in to comment on a image" do
        image = FactoryBot.create(:image)
        post :create, params: {image_id: image.id, comment: { message: 'awesome image'}}
        expect(response).to redirect_to new_user_session_path

      end
      it "should return http status code of not found if the image is not found" do
        user = FactoryBot.create(:user)
        sign_in user
        post :create, params: { image_id: 'SOMETHING', comment: {message: 'awesome image'}}
        expect(response).to have_http_status :not_found
      end
    end
end
