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

ActiveRecord::Schema.define(version: 2018_09_17_105040) do

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "followers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "insta_id", limit: 16777215
    t.string "username", limit: 100, null: false
    t.integer "likes_count"
    t.integer "following_count"
    t.index ["id"], name: "followers_id_uindex", unique: true
    t.index ["username"], name: "followers_username_uindex", unique: true
  end

  create_table "followers_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "follower_id"
    t.index ["follower_id"], name: "users_followers_followers_id_fk"
    t.index ["id"], name: "users_followers_id_uindex", unique: true
    t.index ["user_id"], name: "users_followers_users_id_fk"
  end

  create_table "publications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "caption"
    t.integer "likes_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary "file", limit: 4294967295
    t.index ["id"], name: "media_id_uindex", unique: true
  end

  create_table "user_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "insta_id", limit: 16777215
    t.text "insta_auth_info"
    t.text "user_agent"
    t.text "rank_token"
    t.datetime "created_at"
    t.string "insta_password", limit: 250
    t.integer "user_id"
    t.index ["id"], name: "user_details_id_uindex", unique: true
    t.index ["user_id"], name: "user_details_users_id_fk"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "username", limit: 100, null: false
    t.string "email", limit: 200, null: false
    t.string "password_digest", limit: 500, null: false
    t.text "token"
    t.datetime "expiration_date"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.index ["id"], name: "users_id_uindex", unique: true
    t.index ["username"], name: "users_username_uindex", unique: true
  end

  add_foreign_key "followers_users", "followers", name: "users_followers_followers_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "followers_users", "users", name: "users_followers_users_id_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_details", "users", name: "user_details_users_id_fk"
end
