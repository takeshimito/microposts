class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :set_user, only: [:show, :edit, :update, :destory]
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    set_user
  end

  def update
    set_user
    if @user.update(user_params)
      flash[:success] = 'ユーザ情報が更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザ情報は更新されませんでした'
      render :edit
    end
  end

  def destroy
    set_user
    @user.destroy
    
    flash[:success] = '正常に退会できました'
    redirect_to users_url
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :age, :coment)
  end
end
