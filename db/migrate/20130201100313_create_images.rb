class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.string :thumb_url
      t.string :original_url
      t.text :text_title
      t.text :text_content

      t.timestamps
    end

    add_index :images, :url, unique: true
    add_index :images, :thumb_url, unique: true
  end
end
