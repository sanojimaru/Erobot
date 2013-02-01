class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :site, null: false
      t.string :title

      t.timestamps
    end

    add_index :pages, :site_id
  end
end
