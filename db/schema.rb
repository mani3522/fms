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

ActiveRecord::Schema.define(version: 20170325115357) do

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "startime"
    t.datetime "endtime"
    t.integer  "amount"
    t.string   "venue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eventusers", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  create_table "githubs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teamevents", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teamusers", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teamusers", ["user_id", "created_at"], name: "index_teamusers_on_user_id_and_created_at"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "empid"
    t.date     "dateofbirth"
    t.string   "gender"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "category"
  end

end
