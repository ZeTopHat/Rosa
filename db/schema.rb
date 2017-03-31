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

ActiveRecord::Schema.define(version: 20160520040043) do

  create_table "groups", force: :cascade do |t|
    t.string   "name",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "ours",       default: false
  end

  create_table "service_requests", force: :cascade do |t|
    t.integer "number",       limit: 8
    t.text    "briefdes"
    t.integer "username_id"
    t.text    "longdes"
    t.text    "lastact"
    t.string  "lastactstamp"
    t.string  "locale"
    t.string  "priority"
    t.string  "hours"
    t.string  "contactvia"
    t.string  "queue"
    t.string  "entitlement"
    t.string  "account"
    t.boolean "returned",               default: false
    t.boolean "taken",                  default: false
    t.boolean "ltss",                   default: false
    t.boolean "unassign",               default: false
    t.string  "createdstamp"
  end

  create_table "usernames", force: :cascade do |t|
    t.string "name"
    t.text   "excuse"
  end

end
