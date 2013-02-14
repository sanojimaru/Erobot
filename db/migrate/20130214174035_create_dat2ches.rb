class CreateDat2ches < ActiveRecord::Migration
  def change
    create_table :dat2ches do |t|
      t.string :title
      t.string :url
      t.text :dat

      t.timestamps
    end

    add_index :dat2ches, :url, unique: true
  end
end
