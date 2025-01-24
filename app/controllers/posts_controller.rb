class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "投稿が作成されました！"
    else
      render :new, alert: "投稿の作成に失敗しました。"
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end

