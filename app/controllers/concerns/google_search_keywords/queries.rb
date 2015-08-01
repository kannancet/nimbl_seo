module Queries
  extend ActiveSupport::Concern

  #Function to find queires
  def queries
  	respond_to do |format|
  		format.json{ render json: GoogleSearchPage.search_data(query_params) }
  		format.html {}
    end
  end

  #Limiting Query params
  def query_params
  	params.permit(:type, :input)
  end

end