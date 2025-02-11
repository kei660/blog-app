require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }  # 他のユーザー
  let!(:post) { create(:post, user: user) }  # ログインユーザーの投稿
  let!(:other_post) { create(:post, user: other_user) }  # 他のユーザーの投稿

  before do
    driven_by(:rack_test)  # Capybaraを使用する設定
  end

  it "ログインして投稿を作成できる" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "user[password_confirmation]", with: user.password_confirmation
    click_button "Log in"

 
    expect(page).to have_content("Signed in successfully")

    visit new_post_path
    fill_in "タイトル", with: "テスト投稿"
    fill_in "内容", with: "これはテスト投稿です"
    click_button "投稿する"

    expect(page).to have_content("投稿が完了しました！")
    expect(page).to have_content("テスト投稿")
  end

  it "ログインユーザーが自分の投稿を編集できる" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "user[password_confirmation]", with: user.password_confirmation
    click_button "Log in"


    visit edit_post_path(post)
    fill_in "タイトル", with: "編集された投稿"
    fill_in "内容", with: "内容が編集されました"
    click_button "更新する"

    expect(page).to have_content("投稿が更新されました。")
    expect(page).to have_content("編集された投稿")
  end

  # 3. 他のユーザーの投稿は編集・削除できない
  it "他のユーザーの投稿は編集できない" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "user[password_confirmation]", with: user.password_confirmation
    click_button "Log in"

    visit edit_post_path(other_post)
    expect(page).to have_content("編集権限がありません")
    expect(page).to have_current_path(root_path)
  end

  it "他のユーザーの投稿は削除できない" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "user[password_confirmation]", with: user.password_confirmation
    click_button "Log in"

    visit post_path(other_post)
    expect(page).not_to have_button("削除")
  end

  # 4. 投稿の削除後、トップページにリダイレクトされる
  it "投稿を削除後、トップページにリダイレクトされる" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "user[password_confirmation]", with: user.password_confirmation
    click_button "Log in"

    visit post_path(post)
    click_button "削除"

    expect(page).to have_content("投稿が削除されました")
    expect(page).to have_current_path(root_path)
  end
end