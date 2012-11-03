class SearchResultsController < ApplicationController
  def index
  @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ticket }
    end
  end
end
