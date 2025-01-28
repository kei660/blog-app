require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET #index' do
    it '正しいレスポンスを返すか' do
      get :index
      expect(response).to have_http_status(:success) # HTTPステータスコードが200であることを確認
    end
  end
end