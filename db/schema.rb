# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130201100313) do

  create_table "images", :force => true do |t|
    t.integer  "page_id",    :null => false
    t.string   "url"
    t.string   "thumb_url"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "images", ["page_id"], :name => "index_images_on_page_id"
  add_index "images", ["url"], :name => "index_images_on_url", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.string   "url"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["site_id"], :name => "index_pages_on_site_id"
  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "domain"
    t.string   "name"
    t.string   "rss"
    t.string   "title_css"
    t.string   "img_css"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sites", ["domain"], :name => "index_sites_on_domain", :unique => true

end
