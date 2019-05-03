require 'rails_helper'

RSpec.describe Api::V1::FlowersController, type: :controller do

  describe 'index' do
    context 'given i have some flowers' do
      it 'should return flowers in alphabetical order' do
        flower_1 = create(:flower, name: 'Betty')
        flower_2 = create(:flower, name: 'Aronia')
        flower_3 = create(:flower, name: 'Cecilia')

        get :index
        expect(response.status).to eq(200)
        results = JSON.load(response.body)

        expect(results['flowers'].count).to eq(3)
        expect(results['flowers'][0]['name']).to eq(flower_2.name)
        expect(results['flowers'][1]['name']).to eq(flower_1.name)
        expect(results['flowers'][2]['name']).to eq(flower_3.name)
      end
    end

    context 'given i have no flowers' do
      it 'should return empty array' do
        get :index
        expect(response.status).to eq(200)
        results = JSON.load(response.body)
        expect(results['flowers'].count).to eq(0)
      end
    end
  end

  describe 'search' do
    let!(:flower) { create(:flower, name: 'Aronia') }

    context 'name match' do
      it 'finds the flower' do
        get :search, params: { query: 'aronia' }
        expect(response.status).to eq(200)
        results = JSON.load(response.body)
        expect(results['flowers'].count).to eq(1)
        expect(results['flowers'][0]['name']).to eq(flower.name)
      end
    end

    context 'name mismatch' do
      it 'returns empty' do
        get :search, params: { query: 'bethestha' }
        expect(response.status).to eq(200)
        results = JSON.load(response.body)
        expect(results['flowers'].count).to eq(0)
      end
    end
  end

  describe 'show' do
    it 'should return a flower' do
      flower = create(:flower)
      get :show, params: { id: flower.id }
      expect(response.status).to eq(200)
      result = JSON.load(response.body)
      expect(result['flower']['id']).to eq(flower.id)
    end
  end

  describe 'create' do
    it 'should return create a flower' do
      flower_params = {
          name: 'Rose',
          latin_name: 'Rosa',
          features: 'Features...' ,
          description: 'A rose is a woody perennial flowering plant of the genus Rosa, in the family Rosaceae, or the flower it bears.'
      }
      post :create, params: flower_params
      expect(response.status).to eq(200)
      result = JSON.load(response.body)
      expect(result['flower']['name']).to eq(flower_params[:name])
    end

    it 'should return status 400 and error if no name provided' do
      flower_params = {
          latin_name: 'Rosa',
          features: 'Features...' ,
          description: 'A rose is a woody perennial flowering plant of the genus Rosa, in the family Rosaceae, or the flower it bears.'
      }
      post :create, params: flower_params
      expect(response.status).to eq(400)
      result = JSON.load(response.body)
      expect(result).to have_key('error')
    end

    it 'should return status 400 and error if no latin_name provided' do
      flower_params = {
          name: 'Rose',
          features: 'Features...' ,
          description: 'A rose is a woody perennial flowering plant of the genus Rosa, in the family Rosaceae, or the flower it bears.'
      }
      post :create, params: flower_params
      expect(response.status).to eq(400)
      result = JSON.load(response.body)
      expect(result).to have_key('error')
    end
  end

end
