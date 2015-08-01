class Api::V1::GoogleSearchKeywordsController < API::V1::APIBaseController

	include KeywordUpload
	include ShowReport
	include Queries
end
