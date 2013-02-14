class CreateImage2ches < ActiveRecord::Migration
  def change
    create_table :image2ches do |t|
      t.references :dat2ch
      t.string :url
      t.string :original_url

      t.timestamps
    end

    add_index :image2ches, :dat2ch_id
    add_index :image2ches, :url, unique: true
    add_index :image2ches, :original_url, unique: true
  end
end
