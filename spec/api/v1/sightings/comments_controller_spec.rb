require 'rails_helper'

RSpec.describe Api::V1::Sightings::CommentsController, type: :controller do

  describe 'index' do
    it 'should return the sighting comments from all users' do
      sighting = create(:sighting)
      user_1 = create(:user)
      user_2 = create(:user)
      comment_1 = create(:comment, sighting: sighting, user: user_1)
      comment_2 = create(:comment, sighting: sighting, user: user_2)
      comment_3 = create(:comment, sighting: sighting, user: user_1)

      get :index, params: { sighting_id: sighting.id }
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)

      expect(results['comments'].count).to eq(3)
    end
  end

  describe 'create' do
    it 'should add a comment from the current user' do
      user = create(:user)
      sighting = create(:sighting)

      comment_params = {
          sighting_id: sighting.id,
          comment: 'Wonderful picture!'
      }

      request.headers['Authorization'] = user.to_jwt
      post :create, params: comment_params
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result['comments'].count).to eq(1)
      expect(result['comments'][0]).to have_key('user')
      expect(result['comments'][0]['user']['id']).to eq(user.id)
      expect(result['comments'][0]['comment']).to eq(comment_params[:comment])
    end

    it 'should return status 400 and error if no comment provided' do
      user = create(:user)
      sighting = create(:sighting)

      comment_params = {
          sighting_id: sighting.id
      }

      request.headers['Authorization'] = user.to_jwt
      post :create, params: comment_params
      expect(response.status).to eq(400)
      result = JSON.parse(response.body)
      expect(result).to have_key('error')
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
    it 'should delete a comment' do
      sighting = create(:sighting)
      user = create(:user)
      comment = create(:comment, sighting: sighting, user: user)

      request.headers['Authorization'] = user.to_jwt
      delete :destroy, params: { sighting_id: sighting.id, id: comment.id }
      expect(response.status).to eq(200)
    end

    it 'should return unauthorized when trying to delete someone else\'s comment' do
      sighting = create(:sighting)
      user = create(:user)
      user2 = create(:user)
      comment = create(:comment, sighting: sighting, user: user)

      request.headers['Authorization'] = user2.to_jwt
      delete :destroy, params: { sighting_id: sighting.id, id: comment.id }
      expect(response.status).to eq(401)
    end
  end

end
