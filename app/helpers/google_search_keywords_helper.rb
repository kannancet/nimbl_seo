module GoogleSearchKeywordsHelper

	def set_result(keyword)
		@google_result = keyword.google_search_page
	end
end
