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
end
