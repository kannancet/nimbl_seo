#This module implements import data 
module Importable
  extend ActiveSupport::Concern

  #All class methods are defined here.
  module ClassMethods

    #Function to import operations from CSV.
    def import_data(file, parsing_log_id = new_parsing_log_id)
      notify_on_parsing_log
      @log = ParsingLog.find(parsing_log_id)
      data = parse_data(file)
      update_parsinglog_status
      data
    end

    #Function to parse data
    def parse_data(file)
      data = File.read(file).split(",").map(&:strip)
      sync_data(data)
      data
    end

    #Function to update parsing log status
    def update_parsinglog_status
      @log.update(status: "complete")
    end

    #Function to create new parsing log if parsing log id nil
    def new_parsing_log_id
      log = ParsingLog.create(total_rows_failed: 0, total_rows_suceeded: 0, total_rows_parsed: 0)
      log.id
    end

    #Function to increment parsing log success
    def log_count_on_parsing_log(data = [])
      count = data.size
      @log.update(total_keywords: count)
    end

    #Function to sync keywords
    def sync_keywords(data = [])
      data.each do |keyword|
        GoogleKeyword.create(name: keyword)
      end
    end

    #Function to sync data
    def sync_data(data = [])
      sync_keywords(data)
      log_count_on_parsing_log(data)
    end

    #Notify on parsing log
    def notify_on_parsing_log
      open(OPERATION_IMPORT_LOG, 'a') do |file|
        file.truncate(0)
        file.puts "<<<<<<<<< PARSING LOG AT : #{Time.now} >>>>>>>>>"
      end
    end


  end

end