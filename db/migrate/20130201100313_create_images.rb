class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :page, null: false
      t.string :url
      t.string :thumb_url
      t.text :content

      t.timestamps
    end

    add_index :images, :page_id
    add_index :images, :url, unique: true
  end
end
