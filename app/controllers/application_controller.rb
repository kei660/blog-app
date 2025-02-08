class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  # テスト環境ではCSRFチェックをスキップ
  skip_forgery_protection if Rails.env.test?
  
end
