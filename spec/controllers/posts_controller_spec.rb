require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET /new ' do
    it 'responds with 200 (REDIRECT)' do
      get :new
      expect(response).to have_http_status(302)
    end
  end
end
