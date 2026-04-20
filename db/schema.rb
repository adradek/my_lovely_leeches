# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_20_193335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "import_sources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "memo"
    t.string "name", null: false
    t.integer "type", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.date "collected_on"
    t.datetime "created_at", null: false
    t.bigint "import_source_id", null: false
    t.string "place"
    t.string "point"
    t.string "section"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["import_source_id"], name: "index_imports_on_import_source_id"
  end

  create_table "taxons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "full_name"
    t.string "name", null: false
    t.string "name_ru"
    t.bigint "parent_id"
    t.integer "rank", default: 10, null: false
    t.datetime "updated_at", null: false
    t.index ["name", "rank", "parent_id"], name: "index_taxons_on_name_and_rank_and_parent_id", unique: true, nulls_not_distinct: true
    t.index ["parent_id"], name: "index_taxons_on_parent_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "imports", "import_sources"
  add_foreign_key "taxons", "taxons", column: "parent_id"
end
