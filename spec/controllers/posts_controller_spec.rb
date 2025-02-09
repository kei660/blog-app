require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  render_views
  include FactoryBot::Syntax::Methods 

  describe "GET #index" do
    before do
      @post1 = create(:post, title: "投稿1", content: "内容1", created_at: 1.day.ago)
      @post2 = create(:post, title: "投稿2", content: "内容2", created_at: 2.days.ago)
      @post3 = create(:post, title: "投稿3", content: "内容3", created_at: Time.zone.now)
    end

    it "レスポンスが成功すること" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "全ての投稿を作成日時の降順で取得すること" do
      get :index
      expect(assigns(:posts)).to eq([@post3, @post1, @post2])
    end
  end

  describe "GET #new" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "正常にレスポンスが返されること" do
        get :new
        expect(response).to have_http_status(:ok)
      end

      it "新しいPostオブジェクトがインスタンス変数にセットされていること" do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end
  end

  describe "POST #create" do
    context "新しい投稿を作成できないとき" do
      context "ログインしてない" do
        it "ログインページにリダイレクトされる" do
          get :create
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "ログインしている" do
        before do
          @user = create(:user)
          sign_in @user
        end

        it "タイトルが空欄の状態で投稿する" do
          post = FactoryBot.build(:post, title: '')
          expect(post).not_to be_valid
          expect(post.errors[:title]).to include("can't be blank")
        end

        it "内容が空欄の状態で投稿される" do
          post = FactoryBot.build(:post, content: '')
          expect(post).not_to be_valid
          expect(post.errors[:content]).to include("can't be blank")
        end

        it "タイトルと内容の両方が空欄の状態で投稿される" do
          post = FactoryBot.build(:post, title: '', content: '')
          expect(post).not_to be_valid
          expect(post.errors[:title]).to include("can't be blank")
          expect(post.errors[:content]).to include("can't be blank")
        end
      end
    end

    context "新しく投稿を作成できるとき" do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "タイトルと内容に文字が入力されている状態で投稿される" do
        post_params = FactoryBot.attributes_for(:post)
        post :create, params: { post: post_params }
        expect(Post.count).to eq(1)
        expect(Post.last.title).to eq('テストタイトル')
        expect(Post.last.content).to eq('テストコンテンツ')
        expect(flash[:notice]).to eq('投稿が完了しました！')
      end
    end
  end

  describe "GET #show" do
  let(:post) { create(:post) }  # FactoryBot でテストデータを作成

  it "正常にレスポンスを返すこと" do
    get :show, params: { id: post.id }
    expect(response).to have_http_status(:success)
  end

  it "適切な投稿が@postに格納されること" do
    get :show, params: { id: post.id }
    expect(assigns(:post)).to eq(post) # @post に正しいデータがセットされるか確認
  end
end

describe "GET #edit" do
let(:user) { create(:user) }  # テスト用ユーザーを作成
let(:other_user) { create(:user) }  # 他のユーザーを作成
let(:post) { create(:post, user: user) }  # ログインユーザーの投稿
let(:other_post) { create(:post, user: other_user) }  # 他のユーザーの投稿

before do
  sign_in user  # Devise の `sign_in` ヘルパーを使用（Devise が必要）
end
context "自分の投稿を編集する場合" do
  it "リクエストが成功し、正しいビューが表示されること" do
    get :edit, params: { id: post.id }
    expect(response).to have_http_status(:ok)
    expect(assigns(:post)).to eq(post)  # @post に正しい投稿が入っていること
  end
end

context "他人の投稿を編集しようとした場合" do
  it "トップページにリダイレクトされること" do
    get :edit, params: { id: other_post.id }
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('編集権限がありません。')
  end
end

context "存在しない投稿を指定した場合" do
  it "トップページにリダイレクトされること" do
    get :edit, params: { id: '' }  # 存在しないID
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('編集権限がありません。')
  end
 end
end

end
