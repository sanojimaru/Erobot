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

ActiveRecord::Schema.define(:version => 20130214174122) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "dat2ches", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "dat"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dat2ches", ["url"], :name => "index_dat2ches_on_url", :unique => true

  create_table "image2ches", :force => true do |t|
    t.integer  "dat2ch_id"
    t.string   "url"
    t.string   "original_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "image2ches", ["dat2ch_id"], :name => "index_image2ches_on_dat2ch_id"
  add_index "image2ches", ["original_url"], :name => "index_image2ches_on_original_url", :unique => true
  add_index "image2ches", ["url"], :name => "index_image2ches_on_url", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "page_id",            :null => false
    t.string   "url"
    t.string   "thumb_url"
    t.string   "original_url"
    t.string   "original_thumb_url"
    t.text     "content"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
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
