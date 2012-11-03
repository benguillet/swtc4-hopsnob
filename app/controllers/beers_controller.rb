class BeersController < ApplicationController
  def index
    @beers = Beer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @beers }
    end
  end

  def new
  end

  def create
  end

  def show
    @beer = Beer.find(params[:id])
    @products = Product.all(:include => "beers")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @beer }
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
