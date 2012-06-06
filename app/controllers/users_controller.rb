class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :find_user_by_id, only: [:show]
  before_filter :admin_user, only: [:destroy]
  before_filter :create_users, only: [:new, :create]
  before_filter :destroy_itself, only: [:destroy]
  
  def index
    @users = User.paginate(:page => params[:page])
  end

  def show
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated"
      sign_in @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." unless signed_in?
      end
    end

    def find_user_by_id
      @user = User.find(params[:id])
    end

    def correct_user
      find_user_by_id
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def create_users
      redirect_to(root_path) if signed_in?
    end

    def destroy_itself
      find_user_by_id
      redirect_to(root_path) if current_user?(@user)
    end

end
