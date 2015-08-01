module DeleteKeywords
  extend ActiveSupport::Concern

  #Function to delete all.
  def delete_all
  	GoogleKeyword.destroy_all
  	render partial: "google_search_keywords/report"
  end

end