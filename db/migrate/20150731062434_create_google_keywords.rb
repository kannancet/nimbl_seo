class CreateGoogleKeywords < ActiveRecord::Migration
  def change
    create_table :google_keywords do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
