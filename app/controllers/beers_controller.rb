class BeersController < ApplicationController
  def index
    @beers = Beer.all
    respond_to do |format|
      format.json { render :json => @beers }
      format.html
    end
  end

  def new
  end

  def create
  end

  def show
    beer_id = params[:id]
    products = Product.where(beer_id: beer_id)
    
    liquor_store_ids = []
    products.each { |product| liquor_store_ids.push(product[:liquor_store_id]) }

    @liquor_stores = LiquorStore.find(liquor_store_ids)
    
    respond_to do |format|
      if !@liquor_stores.nil?
        format.json { render :json => @liquor_stores }
      else
        format.json { render :json => {:status => 'error', :message => "trying to get a store that does not exit, id = #{liquor_store_id}"} }
        format.html
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def search_beer
    @beers=Beer.where("LOWER(name) LIKE ?", "%#{params[:name]}%").limit(10).order(:name)

    respond_to do |format|
      format.json {render :json => @beers}
    end
  end
end
