class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    flash[:success] = '投稿をお気に入りにしました'
    redirect_to root_url
  end
  #1行目 Micropostモデルの中からmicropost_id（数値）番目の投稿をmicropostとする
  #2行目 likeメソッドを用いてmicropostをお気に入りにする(favoriteモデルのインスタンス生成)
  
  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:success] = '投稿をお気に入り解除しました'
    redirect_to root_url
  end
end
