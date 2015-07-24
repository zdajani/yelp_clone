class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show,]

  def index
    @restaurants = Restaurant.all
  end

  def new
    if current_user 
      @restaurant = Restaurant.new
    end
  end

  def create
    user = current_user
    @restaurant = user.restaurants.build restaurant_params
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.created_by? current_user
      
    else 
      flash[:notice] = 'You can only edit restaurants which you added'
      redirect_to '/restaurants'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update_as current_user, restaurant_params
    if @restaurant.save
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.destroy_as current_user
      flash[:notice] = 'Restaurant deleted successfully'
    else
      flash[:notice] = 'You can only delete restaurants which you added'
    end
    redirect_to root_path
  end
  
  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

end
