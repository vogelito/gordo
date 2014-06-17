class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :show, :waiting]
  before_action :signed_out_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :show, :waiting]
  before_action :admin_user, only: [:index, :destroy]
  before_action :set_user, only: [:show, :waiting, :reset_password, :check_delivered_order]
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
    @food_item = food_item
  end

  def check_delivered
     @order = get_pending_order
     @food_item = food_item
     render :waiting
  end

  def food_item
     @order.present? ? FoodItem.find(@order.food_item_id) : nil
  end

  def check_delivered_order
    status = get_pending_order.present? ? false : true 
    UserReciptMailer.recipt_email(@user).deliver if status
    respond_to do |format|
      msg = {:message => status }
      format.json { render :json => msg }
    end 
  end

  def forget_password
  end

  def forget_password_token
    if params[:email].present?
      @user = User.find_by_email(params[:email].downcase) 
      if @user.present?
        if @user.update_attribute(:reset_password_code, secure_token)
          UserReciptMailer.forget_password_mail(@user).deliver
        end
        redirect_to(signin_path)
      else
        flash[:error] = "This Email is not Correct."
        redirect_to(forget_password_path)
      end
    else
      flash[:error] = "Email Field can not be Blank."
      redirect_to(forget_password_path)
    end
  end


  def new_password
    @user = User.find_by_reset_token(params[:token])
    unless @user.present?
      flash[:error] = "Your token was invalid"
      redirect_to(signin_path)
    end
  end

  def reset_password
    if @user.reset_new_password(params[:user][:password], params[:user][:password_confirmation])
      sign_in(@user)
      redirect_to root_path
    else
      render :new_password, token: @user.reset_password_code
    end
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
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end
end
