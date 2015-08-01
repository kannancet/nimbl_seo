class CreateGoogleSearchPages < ActiveRecord::Migration
  def change
    create_table :google_search_pages do |t|
      t.integer :google_keyword_id
      t.integer :adword_count_top
      t.integer :adword_count_right
      t.integer :adword_count_total
      t.integer :nonadword_count_total
      t.integer :links_total
      t.text :search_results_total
      t.text :html_code

      t.timestamps null: false
    end
  end
end
