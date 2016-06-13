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

ActiveRecord::Schema.define(version: 20151109172746) do

  create_table "alerts", force: :cascade do |t|
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "alerts_kind",              limit: 4
    t.boolean  "fixed",                    limit: 1,   default: false
    t.integer  "lot_id",                   limit: 4
    t.float    "max_yield",                limit: 24
    t.float    "min_yield",                limit: 24
    t.string   "max_element",              limit: 255
    t.string   "min_element",              limit: 255
    t.float    "region_1_yield",           limit: 24
    t.float    "region_2_yield",           limit: 24
    t.integer  "detected_serial",          limit: 4,   default: 0
    t.integer  "continuously_fail_number", limit: 4,   default: 0
    t.integer  "continuously_fail_bin",    limit: 4,   default: 0
  end

  add_index "alerts", ["lot_id"], name: "index_alerts_on_lot_id", using: :btree

  create_table "data", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "bin",        limit: 4
    t.integer  "serial",     limit: 4, default: 0
    t.integer  "lot_id",     limit: 4
    t.integer  "site",       limit: 4
  end

  add_index "data", ["lot_id"], name: "index_data_on_lot_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.string   "name",                                       limit: 255
    t.boolean  "site_difference_detect_enable",              limit: 1,                  default: true
    t.integer  "site_difference_detect_window",              limit: 4,                  default: 1000
    t.boolean  "continuously_failure_detect_enable",         limit: 1,                  default: true
    t.integer  "continuously_failure_detect_threshold",      limit: 4
    t.boolean  "time_variance_detect_enable",                limit: 1,                  default: true
    t.integer  "time_variance_detect_window_small",          limit: 4,                  default: 200
    t.integer  "time_variance_detect_window_large",          limit: 4,                  default: 1000
    t.float    "time_variance_detect_threshold",             limit: 24
    t.boolean  "different_tester_variance_detect_enable",    limit: 1,                  default: true
    t.integer  "different_tester_variance_detect_window",    limit: 4,                  default: 1000
    t.float    "different_tester_variance_detect_threshold", limit: 24
    t.decimal  "site_difference_detect_threshold",                       precision: 10
  end

  create_table "lots", force: :cascade do |t|
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "name",                               limit: 255
    t.string   "tester",                             limit: 255
    t.integer  "device",                             limit: 4
    t.integer  "total_device_count",                 limit: 4,   default: 2000
    t.integer  "site_number",                        limit: 4,   default: 4
    t.float    "basic_yield",                        limit: 24
    t.integer  "cliff_number",                       limit: 4
    t.float    "first_region_yield",                 limit: 24
    t.float    "second_region_yield",                limit: 24
    t.integer  "generate_mode",                      limit: 4
    t.integer  "device_id",                          limit: 4
    t.boolean  "site_difference_detected",           limit: 1,   default: false
    t.boolean  "continuously_failure_detected",      limit: 1,   default: false
    t.boolean  "time_variance_detected",             limit: 1,   default: false
    t.boolean  "different_tester_variance_detected", limit: 1,   default: false
  end

  add_index "lots", ["device_id"], name: "index_lots_on_device_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.integer  "site_serial", limit: 4
    t.boolean  "site_enable", limit: 1,  default: true
    t.float    "site_yield",  limit: 24
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "lot_id",      limit: 4
  end

  add_index "sites", ["lot_id"], name: "index_sites_on_lot_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "alerts", "lots"
  add_foreign_key "data", "lots"
  add_foreign_key "lots", "devices"
  add_foreign_key "sites", "lots"
end
