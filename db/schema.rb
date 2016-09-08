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

ActiveRecord::Schema.define(version: 20160908142910) do

  create_table "memberships", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string   "status",                default: "submitted", null: false
    t.string   "slug",                                        null: false
    t.integer  "project_id",                                  null: false
    t.integer  "editing_user_id",                             null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "content_cache"
    t.datetime "content_cached_at"
    t.text     "notes"
    t.boolean  "published",             default: false,       null: false
    t.string   "steem_id"
    t.string   "steem_author"
    t.string   "steem_permlink"
    t.string   "steem_category"
    t.string   "steem_parent_permlink"
    t.string   "steem_created"
    t.string   "steem_url"
    t.index ["slug"], name: "index_posts_on_slug"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "code",                                  null: false
    t.string   "name"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "feature_duration_in_days", default: 10, null: false
    t.index ["code"], name: "index_projects_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",         null: false
    t.string   "nick",          null: false
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
