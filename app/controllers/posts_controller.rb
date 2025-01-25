class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]  # ログインしていないと新規投稿や作成ができない

  def index
    @posts = Post.all.order(created_at: :desc)  # 最新の投稿から順番に表示
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "投稿が完了しました！"
    else
      flash[:alert] = "投稿の作成に失敗しました。"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
