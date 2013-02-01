class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :domain
      t.string :name
      t.string :rss
      t.string :title_xpath
      t.string :img_thumb_xpath
      t.string :img_link_xpath

      t.timestamps
    end

    add_index :sites, :domain, unique: true
  end
end
