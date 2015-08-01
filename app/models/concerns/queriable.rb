#This module implements search data 
module Queriable
  extend ActiveSupport::Concern

  #All class methods are defined here.
  module ClassMethods

	  #Function to search data
	  def search_data(params = {})
	  	query_selected = QUERY_BANK.select{ |query| query[:type] == params[:type].to_i }.first
	  	build_and_send_data(query_selected, params[:input])
	  end

	  #Function to build and send data
	  def build_and_send_data(query_selected, input)
	  	if query_selected
			  data = send(query_selected[:method].to_sym, input)
	  	  build_success_output(data)
	    else
	   	  build_fail_output(data)
	    end
	  end

	  #Function to search URLs
	  def url_contains_adword_count(input)
	  	AdwordUrl.where("url LIKE ?", "%#{input}%").count
	  end

	  #Function to show the count of URL in SEO
	  def count_of_url_in_seo(input)
	  	NonAdwordUrl.where(url: input).count
	  end

	  #function to build success output
	  def build_success_output(data)
	  	{data: data, code: 200, result: "success"}
	  end

	  #function to build fail output
	  def build_fail_output(data)
	  	{data: nil, code: 401, result: "fail"}
	  end

	end
end