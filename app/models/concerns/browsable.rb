#This module implements browsing of google keywords
module Browsable
  extend ActiveSupport::Concern

  #Function to browse page
	def browse_page(search)
		response = fetch_via_mechanize(search)
		request_successful(response) ? parse_page(response) : false
	end

	#Function for successful result
	def request_successful(response)
		response.code == "200"
	end

	#function to fetch via proxy
	def fetch_via_mechanize(search)
		agent = Mechanize.new
		page = agent.get(GOOGLE_SEARCH_URL)
		search_form = page.form_with(:name => "f")
		search_form.field_with(:name => "q").value = search    
		agent.submit(search_form)
	end

	#function to parse page in nokogiti
	def parse_page(response)
		Nokogiri::HTML(response.body)
	end

	#Function to  create google search page
	def create_google_search_page(page)
		google_search_page.destroy if reload.google_search_page
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
		page.xpath("//td[@id='rhs_block']").children.xpath("ol/li/div/cite")
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
		page.xpath("//div[@id='center_col']").children[1].xpath("ol/li/div/cite")
	end

	#Function to fet url top
	def fetch_adword_url_top(adword)
		"http://#{adword.text}"
	end

	#Function to fetch url right
	def fetch_adword_url_right(adword)
		adword.text
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
		page.xpath("//div[@id='ires']/ol//cite")
	end

	#Function to fet url for non adword
	def fetch_nonadword_url(adword)
		adword.text
	end

	#Function to find total links 
	def links_total(page)
		nonadword_count_total(page) + adword_count_total(page)
	end

	#Function to search resuls total
	def search_results_total(page)
		page.xpath("//div[@id='resultStats']").text.split(" ")[1].split(",").join
	end

  #All class methods are defined here.
  module ClassMethods

  	#Function to browse and save infos 
  	def browse_and_save_information(data = [])
  		@keywords = GoogleKeyword.where(name: data)

  		@keywords.each do |keyword|
  			execute(keyword)
	  		sleep 2
  		end
  	end

  	#Function to execute output
  	def execute(keyword)
			begin
  			page = browse_information(keyword)
  			save_information(keyword, page) if page
  			notify_pusher(keyword)
  		rescue Exception => e
  			logger.error e.message + "\n " + e.backtrace.join("\n ")
  		end
  	end

  	#Function to browse infos
  	def browse_information(keyword)
  		page = keyword.browse_page(keyword.name)
  		keyword.create_google_search_page(page)
  		page
  	end

  	#Save urls after browsing
  	def save_information(keyword, page)
			keyword.save_adword_urls(page)
			keyword.save_nonadword_urls(page)
  	end

  	#Real time push to complete notify 
  	def notify_pusher(keyword)
  		Pusher.trigger('upload', 'browsing', {info: "successfully completed parsing keyword : #{keyword.name}"})
  	end

  end

end