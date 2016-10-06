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

ActiveRecord::Schema.define(version: 20160919202123) do

  create_table "bucket_blocks", force: :cascade do |t|
    t.integer  "block_number",            null: false
    t.string   "previous",                null: false
    t.datetime "timestamp",               null: false
    t.string   "transaction_merkle_root", null: false
    t.string   "witness",                 null: false
    t.string   "witness_signature",       null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["block_number"], name: "index_bucket_blocks_on_block_number", unique: true
  end

  create_table "bucket_operations", force: :cascade do |t|
    t.string   "type",           null: false
    t.integer  "transaction_id", null: false
    t.string   "payload",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["transaction_id"], name: "index_bucket_operations_on_transaction_id"
    t.index ["type"], name: "index_bucket_operations_on_type"
  end

  create_table "bucket_transactions", force: :cascade do |t|
    t.integer  "block_id",                   null: false
    t.integer  "ref_block_num",              null: false
    t.integer  "ref_block_prefix", limit: 8, null: false
    t.datetime "expiration",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["block_id"], name: "index_bucket_transactions_on_block_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string   "status",                 default: "proposed", null: false
    t.string   "slug",                                        null: false
    t.integer  "project_id",                                  null: false
    t.integer  "editing_user_id",                             null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "content_cache"
    t.datetime "content_cached_at"
    t.text     "notes"
    t.boolean  "published",              default: false,      null: false
    t.string   "steem_id"
    t.string   "steem_author"
    t.string   "steem_permlink"
    t.string   "steem_category"
    t.string   "steem_parent_permlink"
    t.string   "steem_created"
    t.string   "steem_url"
    t.string   "plagiarism_results_url"
    t.datetime "plagiarism_checked_at"
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
