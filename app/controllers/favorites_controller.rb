class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  # お気に入り登録機能と削除機能
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(@micropost)
    flash[:success] = "投稿をお気に入り登録しました。"
    # redairect_backは、このアクションが実行されたページに戻るメソッド。
    # fallback_locationは、戻るべきページがない場合、root_path(トップページ?)に戻る。
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(@micropost)
    flash[:success] = "投稿をお気に入り解除しました。"
    redirect_back(fallback_location: root_path)
  end
end