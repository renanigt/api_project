require 'rails_helper'

RSpec.describe Api::V1::ShortenedUrlsController, type: :controller do
  fixtures :shortened_urls

  describe '#create' do
    context 'with success' do
      before(:each) do
        expect(PullTitleWorker).to receive(:perform_async).with(any_args, 'www.new.com.br')
      end

      it 'creates a new ShortenedUrl' do
        expect {
          post :create, params: { shortened_url: { original_url: 'www.new.com.br' } }
        }.to change { ShortenedUrl.count }.by(1)
      end

      it 'returns status created' do
        post :create, params: { shortened_url: { original_url: 'www.new.com.br' } }
        
        expect(response.status).to eq(201)
      end

      it 'returns the shortened_url with token' do
        post :create, params: { shortened_url: { original_url: 'www.new.com.br' } }

        json_response = JSON.parse(response.body)
        
        expect(json_response['token']).not_to be_empty
      end
    end

    context 'without success' do
      it 'does not create a new ShortenedUrl' do
        expect {
          post :create, params: { shortened_url: { original_url: '' } }
        }.not_to change { ShortenedUrl.count }
      end

      it 'should returns unprocessable_entity' do
        post :create, params: { shortened_url: { original_url: '' } }
        
        expect(response.status).to eq(422)
      end

      it 'should returns errors' do
        post :create, params: { shortened_url: { original_url: '' } }
        
        json_response = JSON.parse(response.body)

        expect(json_response['original_url'][0]).to eq("can't be blank")
      end
    end
  end

  describe '#show' do
    let!(:yahoo) { shortened_urls(:yahoo) }

    it 'returns success' do
      get :show, params: { token: yahoo.token }

      expect(response.status).to eq(200)
    end

    it 'returns the shortened_url with original_url' do
      get :show, params: { token: yahoo.token }      

      json_response = JSON.parse(response.body)

      expect(json_response['original_url']).to eq(yahoo.original_url)
    end
  end

  describe '#top' do
    it 'returns the top X shortened_url' do
      get :top, params: { number: 3 }

      json_response = JSON.parse(response.body)

      first = json_response.first
      second = json_response.second
      third = json_response.third

      expect(first['original_url']).to eq('www.rails.com')
      expect(second['original_url']).to eq('www.gmail.com')
      expect(third['original_url']).to eq('www.sublime.com')
    end
  end
end







