class ParsingLog < ActiveRecord::Base

  has_attached_file :operation_file
  validates_attachment_content_type :operation_file, :content_type => ["text/csv"]

  #Find running parsers
  def self.running_parser
  	where(status: "parsing")
  end
end
