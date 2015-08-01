class GoogleKeyword < ActiveRecord::Base

	#Relations goes here
	has_one :google_search_page, dependent: :destroy

	include Importable
	include Browsable

	#Function to ahow all data
	def self.all_data(page)
		includes(google_search_page: [:adword_urls, :non_adword_urls])
  	.page(page).per(20)
	end
end
