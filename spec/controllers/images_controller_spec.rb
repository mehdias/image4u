require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe "images#show action" do
    it "should successfully show the page if the image is found" do
      image = FactoryBot.create(:image)
      get :show, params: {id: image.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the image is not found" do
      get :show, params: {id: 'TACOCAT'}
      expect(response).to have_http_status(:not_found)

    end
  end
  describe "images#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "images#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path

    end
    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
        sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "images#create action" do 
    it "should require users to be logged in" do
      post :create, params: {image: {message: "Hello"}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should create a new image in our database" do
      user = FactoryBot.create(:user)
        sign_in user

      post :create, params: {image: {message: 'Hello!'}}
      expect(response).to redirect_to root_path

      image = Image.last
      expect(image.message).to eq("Hello!")
      expect(image.user). to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user
      image_count = Image.count
      post :create, params: {image: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(image_count).to eq Image.count
    end



  end
end
