class AddTotalKeywordsToParsingLog < ActiveRecord::Migration
  def change
    add_column :parsing_logs, :total_keywords, :integer
  end
end
