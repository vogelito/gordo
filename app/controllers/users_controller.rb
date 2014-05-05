class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :show, :waiting]
  before_action :signed_out_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :show, :waiting]
  before_action :admin_user, only: [:index, :destroy]
  before_action :set_user, only: [:show, :waiting]
  before_action :route_selector, only: [:index, :show, :waiting]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @order = get_pending_order
    @food_item = @order == nil ? nil : FoodItem.find(@order.food_item_id)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Gordo!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    user_to_delete = User.find(params[:id])
    if (current_user?(user_to_delete))
      flash[:error] = "You cannot delete yourself!"
    else
      user_to_delete.destroy
      flash[:success] = "User deleted."
    end
    redirect_to users_url
  end

  def waiting
    @order = get_pending_order
    @food_item = @order == nil ? nil : FoodItem.find(@order.food_item_id)
  end

  def check_delivered
     @order = get_pending_order
     render :waiting
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :cellphone, :default_address, :password, :password_confirmation)
    end

    # Before filters

    def signed_out_user
      redirect_to(root_url) if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
