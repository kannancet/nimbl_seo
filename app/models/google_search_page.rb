class GoogleSearchPage < ActiveRecord::Base
	
	include Queriable

	#Relations goes here
	belongs_to :google_keyword
	has_many :non_adword_urls, dependent: :destroy
	has_many :adword_urls, dependent: :destroy
end
