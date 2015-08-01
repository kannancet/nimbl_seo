module ShowReport
  extend ActiveSupport::Concern

  #Function to show index
  def index
    respond_to do |format|
      format.html {render :index}
      format.json {render :index}
    end
  end

  #Functiont o load report alone
  def report
  	if request.xhr?
  	  render partial: "report" 
  	end
  end

  #Function to load report
  def load_report
  	@report = GoogleKeyword.all_data(params[:page] || 1)
  end

end