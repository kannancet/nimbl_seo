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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150731095730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adword_urls", force: :cascade do |t|
    t.string   "url"
    t.string   "position"
    t.integer  "google_search_page_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "categories_operations", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "operation_id"
  end

  add_index "categories_operations", ["category_id"], name: "index_categories_operations_on_category_id", using: :btree
  add_index "categories_operations", ["operation_id"], name: "index_categories_operations_on_operation_id", using: :btree

  create_table "google_keywords", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "google_search_pages", force: :cascade do |t|
    t.integer  "google_keyword_id"
    t.integer  "adword_count_top"
    t.integer  "adword_count_right"
    t.integer  "adword_count_total"
    t.integer  "nonadword_count_total"
    t.integer  "links_total"
    t.text     "search_results_total"
    t.text     "html_code"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "non_adword_urls", force: :cascade do |t|
    t.string   "url"
    t.string   "position"
    t.integer  "google_search_page_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "parsing_logs", force: :cascade do |t|
    t.integer  "total_rows_parsed"
    t.integer  "total_rows_suceeded"
    t.integer  "total_rows_failed"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "operation_file_file_name"
    t.string   "operation_file_content_type"
    t.integer  "operation_file_file_size"
    t.datetime "operation_file_updated_at"
    t.string   "status",                      default: "parsing"
    t.integer  "total_keywords"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
