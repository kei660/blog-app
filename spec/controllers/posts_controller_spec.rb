require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "GET #index" do
    before do
      # FactoryBotを使用してテストデータ作成
      @post1 = create(:post, title: "投稿1", content: "内容1", created_at: 1.day.ago)
      @post2 = create(:post, title: "投稿2", content: "内容2", created_at: 2.days.ago)
      @post3 = create(:post, title: "投稿3", content: "内容3", created_at: Time.zone.now)
      allow(controller).to receive(:render).and_return(nil) # ビュー無効化
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
      expect(response).to redirect_to(new_user_session_path)  # ログインページにリダイレクト
    end
  end

  context "ログインしている場合" do
    before do
      # ログインユーザーを作成してサインイン
      @user = create(:user)
      sign_in @user
    end

    it "正常にレスポンスが返されること" do
      get :new
      expect(response).to have_http_status(:ok)  # 200 OK が返されること
    end

    it "新しいPostオブジェクトがインスタンス変数にセットされていること" do
      get :new
      expect(assigns(:post)).to be_a_new(Post)  # @post が新しいPostオブジェクトであること
    end
  end
end

end
