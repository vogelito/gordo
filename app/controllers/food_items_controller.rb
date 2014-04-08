class FoodItemsController < ApplicationController
  before_action :signed_in_user, only: [:index, :destroy, :create, :new, :toggle_active]
  before_action :admin_user, only: [:index, :destroy, :create, :new, :toggle_active]

  def index
    @food_items = FoodItem.paginate(page: params[:page])
  end

  def show
    @food_item = FoodItem.find(params[:id])
    @order = Order.new
  end

  def toggle_active
    @food_item = FoodItem.find(params[:id])
    @food_item.toggle!(:active)
  end

  def active
    @food_items = Array.new
    FoodItem.all.each do |fi|
      break if @food_items.length == 2
      @food_items.push(fi) if fi.active
    end
  end

  def new
    @food_item = FoodItem.new
  end

  def destroy
    FoodItem.find(params[:id]).destroy
    flash[:success] = "Food Item deleted."
    redirect_to food_items_url
  end

  def create
    @food_item = FoodItem.new(food_item_params)

    if @food_item.save
      flash[:success] = "Food Item \"#{@food_item.title}\" added"
      redirect_to food_items_path
    else
      render 'new'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def food_item_params
      params.require(:food_item).permit(:title, :description, :picture_url, :price, :active)
    end
end
