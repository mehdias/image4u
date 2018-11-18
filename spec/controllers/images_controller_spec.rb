require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe "images#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "images#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "images#create action" do 
    it "should create a new image to the database" do
      post :create, params: {image: {message: 'Hello!'}}
      expect(response).to redirect_to root_path

      image = Image.last
      expect(image.message).to eq("Hello!")
    end
  end
end
