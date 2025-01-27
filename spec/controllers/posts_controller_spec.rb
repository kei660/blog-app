require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { { title: 'テストタイトル', content: 'テストコンテンツ', } } 
  let(:invalid_attributes) { { title: '', content: '', } }

  before do
    sign_in user # Deviseのログインヘルパーを利用
  end

  describe 'GET #index' do
    it 'すべての投稿を取得し表示する' do
      post
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:posts).first).to eq(post)
    end
  end

  describe 'GET #show' do
    it '指定した投稿を表示する' do
      get :show, params: { id: post.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #new' do
    context 'ログインしている場合' do
      before { sign_in user }

      it '新しい投稿作成画面を表示する' do
        get :new
        expect(response).to have_http_status(:success)
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトする' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do

      before { sign_in user }

      context '有効なパラメータの場合' do
        it '投稿を作成し、トップページにリダイレクトする' do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
          expect(response).to redirect_to(root_path)
        end
      end

      context '無効なパラメータの場合' do
        it '投稿が作成されず、newテンプレートが再描画される' do
          expect {
            post :create, params: { post: invalid_attributes }
          }.not_to change(Post, :count)
          expect(response).to render_template(:new)
        end
      end
    end

    context 'ログインしていない場合' do
      before do
        sign_out user
      end

      it 'ログインページにリダイレクトする' do
        post  :create, params: { post: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

