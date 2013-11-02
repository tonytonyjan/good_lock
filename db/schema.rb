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

ActiveRecord::Schema.define(version: 20131102032003) do

  create_table "events", force: true do |t|
    t.integer  "user_id",                      null: false
    t.string   "event_id",                     null: false
    t.string   "state",      default: "unset", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_id", "user_id"], name: "index_events_on_event_id_and_user_id", unique: true
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.text     "token"
    t.text     "refresh_token"
    t.integer  "expires_at"
    t.boolean  "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true

end
