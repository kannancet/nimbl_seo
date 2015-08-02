module KeywordUpload
  extend ActiveSupport::Concern

 	#Function to upload keywords
  def upload
    if valid_data? 
      create_parsing_log   
      add_upload_to_queue
      render text: "Upload Successful. Parsing in progress.."
    else
      render tect: "Failed to upload"
    end
  end

  #Function to create parsing log
  def create_parsing_log
    @log = ParsingLog.new
    @log.operation_file = upload_params
    @log.save
  end

  #Function to add upload to queue
  def add_upload_to_queue
		Resque.enqueue(UploadParser, @log.id)
  end

  #Function to permit upload params
  def upload_params
    params.require(:upload_file)
  end

  #Funtion to check if valid data
  def valid_data?
    not_blank = (params[:upload_file] != "")
    is_csv = (params[:upload_file].content_type == "text/csv")

    not_blank && is_csv
  end
    
end