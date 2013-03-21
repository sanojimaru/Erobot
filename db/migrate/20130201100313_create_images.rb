class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.string :thumb_url
      t.string :original_url
      t.text :title

      t.timestamps
    end

    add_index :images, :original_url, unique: true
  end
end
