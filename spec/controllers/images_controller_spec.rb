require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
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
  describe "images#edit action" do
    it "should not let a user who did not create the image to edit image" do
      image = FactoryBot.create(:image)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {id: image.id}
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthorized user to edit an image" do
      image = FactoryBot.create(:image)
      get :edit, params: {id: image.id}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the image is found" do
      image = FactoryBot.create(:image)
      sign_in image.user
      get :edit, params: {id: image.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: {id: 'NO'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "images#update action" do
    it "should not let a user who did not create the image to update it" do
      image = FactoryBot.create(:image)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {id: image.id, image: { message: 'Hello'}}
      expect(response).to have_http_status(:forbidden)
    end
    it "should not allow unauthenticated user to update an image" do
      image = FactoryBot.create(:image)
      patch :update, params: {id: image.id, image: { message:'Hello'}}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update images" do
      image = FactoryBot.create(:image, message: "Initial Value")
      sign_in image.user
      patch :update, params: {id: image.id, image: {message: 'Changed'}}
      expect(response).to redirect_to root_path
      image.reload
      expect(image.message).to eq "Changed"
    end
    it "should have http 404 error if the image cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: {id: 'NO', image: {message: 'Changed'}}
      expect(response).to have_http_status(:not_found)
    end
    it "should render the edit form with an http status of unprocessable_entity" do
      image = FactoryBot.create(:image, message: "Initial Value")
      sign_in image.user
      patch :update, params: {id: image.id, image: {message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      image.reload
      expect(image.message).to eq "Initial Value"
    end
   
  end

  describe "images#destroy action" do
    it "should not let the user who did not create the image to delete it" do
      image = FactoryBot.create(:image)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: {id: image.id}
      expect(response).to have_http_status(:forbidden)
    end
    it "should not let unauthenticated user to destroy an image" do
      image = FactoryBot.create(:image)
      delete :destroy, params: {id: image.id}
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy images" do
      image = FactoryBot.create(:image)
      sign_in image.user
      delete :destroy, params: {id: image.id}
      expect(response).to redirect_to root_path
      image = Image.find_by_id(image.id)
      expect(image).to eq nil
    end
    it "should return a 404 message if we cannot find an image with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'NO'}
      expect(response).to have_http_status (:not_found)
    end
  end
end
