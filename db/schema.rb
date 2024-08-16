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

ActiveRecord::Schema[7.1].define(version: 2024_08_16_100434) do
  create_table "attendances", force: :cascade do |t|
    t.integer "time"
    t.string "absence_reason"
    t.string "progress_report"
    t.integer "minute_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_attendances_on_member_id"
    t.index ["minute_id"], name: "index_attendances_on_minute_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.integer "meeting_week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hiatuses", force: :cascade do |t|
    t.integer "member_id", null: false
    t.date "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_hiatuses_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar_url"
    t.string "provider"
    t.string "uid"
    t.integer "course_id", null: false
    t.index ["course_id"], name: "index_members_on_course_id"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "minutes", force: :cascade do |t|
    t.string "release_branch"
    t.string "release_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "other"
    t.date "next_date"
    t.integer "course_id", null: false
    t.date "date"
    t.boolean "sent_invitation", default: false
    t.index ["course_id", "date"], name: "index_minutes_on_course_id_and_date", unique: true
    t.index ["course_id"], name: "index_minutes_on_course_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minute_id", null: false
    t.index ["minute_id"], name: "index_topics_on_minute_id"
  end

  add_foreign_key "attendances", "members"
  add_foreign_key "attendances", "minutes"
  add_foreign_key "hiatuses", "members"
  add_foreign_key "members", "courses"
  add_foreign_key "minutes", "courses"
  add_foreign_key "topics", "minutes"
end
