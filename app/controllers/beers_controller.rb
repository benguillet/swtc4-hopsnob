class BeersController < ApplicationController
  def index
    @beers = Beer.all
    respond_to do |format|
      format.json { render :json => @beers }
    end
  end

  def new
  end

  def create
  end

  def show
    beer_id = params[:id]
    @beer = Beer.where(id: beer_id)
    @products = Product.all(:include => "beers")
    
    respond_to do |format|
      if !@beer.nil?
        format.json { render :json => @beer }
      else
        format.json { render :json => {:status => 'error', :message => "trying to get a that does not exit, id = #{beer_id}"} }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
