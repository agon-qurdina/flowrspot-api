require 'rails_helper'

RSpec.describe Api::V1::Sightings::LikesController, type: :controller do

  describe 'index' do
    it 'should return all sighting likes' do
      sighting = create(:sighting)
      user_1 = create(:user)
      user_2 = create(:user)
      create(:like, sighting: sighting, user: user_1)
      create(:like, sighting: sighting, user: user_2)
      create(:like, sighting: sighting, user: user_1)

      get :index, params: { sighting_id: sighting.id }
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)

      expect(results['likes'].count).to eq(3)
    end
  end

  describe 'create' do
    it 'should add a like from the current user' do
      user = create(:user)
      sighting = create(:sighting)

      like_params = {
          sighting_id: sighting.id
      }

      request.headers['Authorization'] = user.to_jwt
      post :create, params: like_params
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result['likes'].count).to eq(1)
      expect(result['likes'].map { |like| like['user']['id'] }).to include(user.id)
    end

    it 'should return status 404 if wrong sighting_id is provided' do
      user = create(:user)

      request.headers['Authorization'] = user.to_jwt
      post :create, params: { sighting_id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should return status 401 if the user is not logged in' do
      sighting = create(:sighting)

      like_params = {
          sighting_id: sighting.id
      }

      post :create, params: like_params
      expect(response.status).to eq(401)
    end
  end

  describe 'destroy' do
    it 'should remove like' do
      sighting = create(:sighting)
      user = create(:user)
      create(:like, sighting: sighting, user: user)

      request.headers['Authorization'] = user.to_jwt
      delete :destroy, params: { sighting_id: sighting.id }
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results['likes'].map { |like| like['user']['id'] }).not_to include(user.id)
    end
  end

end
