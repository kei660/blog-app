require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }  # FactoryBot でUserインスタンスを作成

    it"emailがあり、パスワードとパスワード（確認用）があれば有効" do
      expect(user).to be_valid
    end

    it"emailが空欄の場合は無効" do
      user.email= ''
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it"パスワードが空欄の場合は無効" do
      user.password= ''
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it"パスワードとパスワード（確認用）が一致していない場合は無効" do
      user.password_confirmation = "different_password"
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end