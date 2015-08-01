class CreateAdwordUrls < ActiveRecord::Migration
  def change
    create_table :adword_urls do |t|
      t.string :url
      t.string :position
      t.integer :google_search_page_id

      t.timestamps null: false
    end
  end
end
