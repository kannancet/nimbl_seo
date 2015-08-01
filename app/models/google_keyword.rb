class GoogleKeyword < ActiveRecord::Base

	#Relations goes here
	has_one :google_search_page, dependent: :destroy

	include Importable
	include Browsable

	#Function to ahow all data
	def self.all_data
		includes(google_search_page: [:adword_urls, :non_adword_urls])
  	.page(1).per(20)
	end
end
