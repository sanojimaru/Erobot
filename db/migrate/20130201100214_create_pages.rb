class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :site, null: false
      t.string :url
      t.string :title

      t.timestamps
    end

    add_index :pages, :site_id
    add_index :pages, :url, unique: true
  end
end
