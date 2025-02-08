class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] # ログインしていない場合の制限
  before_action :set_post, except: [:index, :new, :create]
  before_action :authorize_user!, only: [:edit, :update, :destroy] # 投稿者のみ許可
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @posts = Post.all.order(created_at: :desc)  # 最新の投稿から順番に表示
  end

  def new
    @post = Post.new
  end

def create
  @post = current_user.posts.build(post_params)
    if @post.save
       redirect_to @post, notice: "投稿が完了しました！" 
    else
      flash[:alert] = '投稿の作成に失敗しました'
    render :new, status: :unprocessable_entity  # 422 ステータスコードを返す
    end
  end



  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '編集権限がありません。'
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      render :edit, status: :unprocessable_entity
       redirect_to root_path, alert: '編集権限がありません。'
    end
  end

  
  

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to root_path, notice: '投稿が削除されました。'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '編集権限がありません。'
  end

private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to root_path, alert: '編集権限がありません。'
    end
  end


  def post_params
    params.require(:post).permit(:title, :content)
  end
end

