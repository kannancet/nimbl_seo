class GoogleSearchKeywordsController < ApplicationController
	before_action :load_report, only: [:report, :index, :delete_all]

	include KeywordUpload
	include ShowReport
	include DeleteKeywords
	include Queries
end
