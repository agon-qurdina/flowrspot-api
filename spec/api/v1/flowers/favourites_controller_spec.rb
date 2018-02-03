require 'rails_helper'

RSpec.describe Api::V1::Flowers::FavouritesController, type: :controller do

  describe 'index' do
    it 'should return user\'s favourites flowers' do
      user1 = create(:user)
      user2 = create(:user)
      flower1 = create(:flower)
      flower2 = create(:flower)
      flower3 = create(:flower)
      create(:favourite, user: user1, flower: flower1)
      create(:favourite, user: user2, flower: flower2)
      create(:favourite, user: user1, flower: flower3)

      request.headers['Authorization'] = user1.to_jwt
      get :index
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results['favourites'].count).to eq(2)
    end
  end

  describe 'create' do
    it 'should add a favourite flower' do
      user = create(:user)
      flower = create(:flower)

      favourite_params = {
          flower_id: flower.id
      }

      request.headers['Authorization'] = user.to_jwt
      post :create, params: favourite_params
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result['favourites'].count).to eq(1)
      expect(result['favourites'].map { |favourite| favourite['flower']['id'] }).to include(flower.id)
    end

    it 'should return status 404 if wrong flower_id is provided' do
      user = create(:user)

      request.headers['Authorization'] = user.to_jwt
      post :create, params: { flower_id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should return status 401 if the user is not logged in' do
      flower = create(:flower)

      flower_params = {
          flower_id: flower.id
      }

      post :create, params: flower_params
      expect(response.status).to eq(401)
    end
  end

  describe 'destroy' do
    it 'should remove user\'s favourite flower' do
      flower = create(:flower)
      user = create(:user)
      create(:favourite, flower: flower, user: user)

      request.headers['Authorization'] = user.to_jwt
      delete :destroy, params: { flower_id: flower.id }
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results['favourites'].map { |favourite| favourite['flower']['id'] }).not_to include(flower.id)
    end
  end

end
