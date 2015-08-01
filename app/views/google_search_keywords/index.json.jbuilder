json.array!(@report) do |keyword|
  json.extract! keyword, :name

  json.google_search_page do |json|
   json.(keyword.google_search_page, :adword_count_top, :adword_count_right, :adword_count_total, :nonadword_count_total, :links_total, :search_results_total, :html_code)
  end

  json.adword_urls keyword.google_search_page.adword_urls, :url, :position
  json.non_adword_urls keyword.google_search_page.non_adword_urls, :url, :position
end