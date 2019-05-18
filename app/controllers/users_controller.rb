class UsersController < ApplicationController
  # アクションが実行される前に、前もって実行すべきアクションが記述されている。
  # ユーザがログインしていなければ操作できないアクションが記述されている。
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]
  
  # idのカラムを基準にdesc(降順)にuserが表示される。今回の場合1ページ当たり、25件のユーザが表示。
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id]) # userのレコードの１つを、paramsによってURLのパラメータやデータを全て受け取れる
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end
  
  def new
    @user= User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user 
    else
    # 登録に失敗した場合、newファイルを表示する。
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings 
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @favorite_microposts = @user.favorite_microposts.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    #requireでPOSTで受け取る値のキーを設定。
    #permitで許可するカラムを設定。ここではname, email, password属性の値だけDBに入れるのを許可。
  end
end