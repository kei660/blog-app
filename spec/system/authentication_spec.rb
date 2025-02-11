require 'rails_helper'

RSpec.describe "ユーザー認証", type: :system do
  let!(:user) { create(:user) }
  let(:post) { create(:post, user: user) }


  before do
    driven_by(:rack_test) # JavaScriptを使用しないテストドライバ
  end

  context "新規ユーザー登録" do
    it "新規ユーザーが登録できる" do
      visit new_user_registration_path # Deviseの新規登録ページへ移動
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"

      expect(page).to have_content "Welcome! You have signed up successfully." # Deviseのデフォルトメッセージ
    end
  end

  context "ログイン" do
    it "ログイン後、トップページにリダイレクトされる" do
      user # 事前にユーザーを作成
      visit new_user_session_path # Deviseのログインページへ移動
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "user[password_confirmation]", with: user.password_confirmation
      click_button "Log in"

      expect(page).to have_current_path(root_path) # トップページにリダイレクトされることを確認
      expect(page).to have_content "Signed in successfully."
    end

    it "誤ったパスワードでログインするとエラーメッセージが出る" do
      user # 事前にユーザーを作成
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      fill_in "Password confirmation", with: "wrongpassword"
      click_button "Log in"

      expect(page).to have_content "Invalid Email or password."
    end

    it"誤ったemailでログインするとエラーメッセージがでる" do
      user # 事前にユーザーを作成
      visit new_user_session_path
      fill_in "Email", with: "test@gmail.com"
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password_confirmation
      click_button "Log in"

      expect(page).to have_content "Invalid Email or password."
    end

    context '未ログインの状態で' do
      it '投稿の作成ページにアクセスするとログインページにリダイレクトされる' do
        visit new_post_path
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
  
      it '投稿の編集ページにアクセスするとトップページにリダイレクトされる' do
        visit edit_post_path(post)
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('編集権限がありません。')
      end
    end
  end
end