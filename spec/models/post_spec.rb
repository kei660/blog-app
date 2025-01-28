require 'rails_helper'

RSpec.describe Post, type: :model do
  # FactoryBot を利用してテストデータを作成
  let(:user) { create(:user) } # ユーザーを作成

  describe 'バリデーションのテスト' do
    it 'タイトルと内容があれば有効' do
      post = Post.new(title: 'テスト投稿', content: 'これはテスト内容です', user: user)
      expect(post).to be_valid
    end

    it 'タイトル、内容、ユーザーが揃っていれば有効' do
    post = Post.new(title: 'A title', content: 'Some content', user: user)
    expect(post).to be_valid
    end

    it 'タイトルが空の場合は無効' do
      post = Post.new(title: '', content: 'これはテスト内容です', user: user)
      expect(post).not_to be_valid
    end

    it '内容が空の場合は無効' do
      post = Post.new(title: 'テスト投稿', content: '', user: user)
      expect(post).not_to be_valid
    end

    it 'ユーザーが紐づいていない場合は無効' do
      post = Post.new(title: 'テスト投稿', content: 'これはテスト内容です', user: nil)
      expect(post).not_to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    it { should belong_to(:user) }
  end
end
