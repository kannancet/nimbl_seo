#This module implements browsing of google keywords
module Browsable
  extend ActiveSupport::Concern

  #Function to browse page
	def browse_page
		url = GOOGLE_SEARCH_URL + name
		response = fetch_url_via_proxy(url)
		request_successful(response) ? parse_page(response) : false
	end

	#Function for successful result
	def request_successful(response)
		response.code == "200"
	end

	#function to fetch via proxy
	def fetch_url_via_proxy(url)
		Tor::HTTP.get(URI(url))
	end

	#function to parse page in nokogiti
	def parse_page(response)
		Nokogiri::HTML(response.body)
	end

	#Function to  create google search page
	def create_google_search_page(page)
		GoogleSearchPage.find_or_create_by(google_keyword_id: id,
																			 adword_count_top: adword_count_top(page),
																			 adword_count_right: adword_count_right(page),
																			 adword_count_total: adword_count_total(page),
																			 nonadword_count_total: nonadword_count_total(page),
						                           links_total: links_total(page),
						                           search_results_total: search_results_total(page),
						                           html_code: page.to_s
						                          )
	end

	#Function to  save adword urls
	def save_adword_urls(page)
		save_adword_urls_right(page) 
		save_adword_urls_top(page)
	end

	#Function to  save adword urls on right
	def save_adword_urls_right(page) 
		adword_urls_right(page).each do |url|
			create_adword_url(url, "right")
		end
	end

	#Function to  save adword urls on top
	def save_adword_urls_top(page)
		adword_urls_top(page).each do |url|
			create_adword_url(url, "top")
		end
	end

	#Function to  save non-adword urls
	def save_nonadword_urls(page)
		nonadword_urls(page).each do |url|
			create_nonadword_url(url, "center")
		end
	end

	#Function to  save adword urls
	def create_adword_url(url, position)
		AdwordUrl.find_or_create_by(url: url,
																position: position,
																google_search_page_id: reload.google_search_page.id)
	end	

	#Function to  save non-adword urls
	def create_nonadword_url(url, position)
		NonAdwordUrl.find_or_create_by(url: url,
										               position: position,
										               google_search_page_id: reload.google_search_page.id)
	end

	#Function to  count adword right
	def adword_count_right(page)
		adword_urls_right(page).length
	end

	#Function to  get adword url right
	def adword_urls_right(page)
		adwords_xpath_right(page).inject([]) do |result, adword|
			result << fetch_adword_url_right(adword)
		end
	end

	#Function to  search adword url right
	def adwords_xpath_right(page)
		page.xpath(PAGE_RIGHT_HAND_SIDE).select.each_with_index { |str, i| i.odd? }
	end

	#Function to  count adword top
	def adword_count_top(page)
		adword_urls_top(page).length
	end

	#Function to  search adword url top
	def adword_urls_top(page)
		adwords_xpath_top(page).inject([]) do |result, adword|
			result << fetch_adword_url_top(adword)
		end
	end

	#Xpath syntax set
	def adwords_xpath_top(page)
		page.xpath(PAGE_TOP_HAND_SIDE)
	end

	#Function to fet url top
	def fetch_adword_url_top(adword)
		adword.attributes['href'].value.split('&adurl=')[1]
	end

	#Function to fetch url right
	def fetch_adword_url_right(adword)
		adword.attributes['href'].value
	end

	#Function to find adword total
	def adword_count_total(page)
		adword_count_top(page) + adword_count_right(page)
	end

	#Functiont o find non adword total
	def nonadword_count_total(page)
		nonadword_urls(page).length
	end

	#Function to find non adword urls
	def nonadword_urls(page)
		nonadwords_xpath(page).inject([]) do |result, adword|
			result << fetch_nonadword_url(adword)
		end		
	end

	#Function to xpath non adwords
	def nonadwords_xpath(page)
		page.xpath(PAGE_RESULT_SIDE).children.xpath(RESULT_BLOCK_ANCHOR_TAG)
	end

	#Function to fet url for non adword
	def fetch_nonadword_url(adword)
		adword.attributes['href'].value
	end

	#Function to find total links 
	def links_total(page)
		nonadword_count_total(page) + adword_count_total(page)
	end

	#Function to search resuls total
	def search_results_total(page)
		page.xpath(TOTAL_RESULT_TEXT_BLOCK).first.text.split("results")[0].split("About")[1].strip.split(",").join().to_s rescue 0
	end

  #All class methods are defined here.
  module ClassMethods

  	#Function to browse and save infos 
  	def browse_and_save_information(data = [])
  		@keywords = GoogleKeyword.where(name: data)

  		@keywords.each do |keyword|
  			page = browse_information(keyword)
  			save_information(keyword, page) if page
  			sleep 1
  		end

  		notify_pusher
  	end

  	#Function to browse infos
  	def browse_information(keyword)
  		page = keyword.browse_page
  		keyword.create_google_search_page(page)
  		page
  	end

  	#Save urls after browsing
  	def save_information(keyword, page)
			keyword.save_adword_urls(page)
			keyword.save_nonadword_urls(page)
  	end

  	#Real time push to complete notify 
  	def notify_pusher
  		Pusher.trigger('upload', 'browsing', {info: 'successfully completed parsing'})
  	end

  end

end