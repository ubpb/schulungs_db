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

ActiveRecord::Schema.define(version: 2018_09_25_114121) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "categories_training_courses", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "training_course_id"
    t.index ["category_id"], name: "index_categories_training_courses_on_category_id"
    t.index ["training_course_id"], name: "index_categories_training_courses_on_training_course_id"
  end

  create_table "registrations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "training_course_id", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.text "notes"
    t.string "salutation", null: false
    t.string "email"
    t.string "field_of_interest"
    t.text "internal_notes"
    t.boolean "dsgvo_consent", default: false, null: false
    t.timestamp "sent_reminder_message_at"
    t.index ["training_course_id"], name: "index_registrations_on_training_course_id"
  end

  create_table "target_audiences", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "target_audiences_training_courses", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "target_audience_id"
    t.bigint "training_course_id"
    t.index ["target_audience_id"], name: "index_target_audiences_training_courses_on_target_audience_id"
    t.index ["training_course_id"], name: "index_target_audiences_training_courses_on_training_course_id"
  end

  create_table "training_courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.string "location", null: false
    t.date "date", null: false
    t.boolean "published", default: false, null: false
    t.text "description"
    t.boolean "registration_required", default: false, null: false
    t.integer "max_no_of_participants", default: 0, null: false
    t.text "learning_targets"
    t.integer "duration"
    t.string "time"
    t.integer "number_of_participants"
    t.text "reminder_message"
    t.index ["date"], name: "index_training_courses_on_date"
    t.index ["published"], name: "index_training_courses_on_published"
  end

  add_foreign_key "categories_training_courses", "categories"
  add_foreign_key "categories_training_courses", "training_courses"
  add_foreign_key "registrations", "training_courses"
  add_foreign_key "target_audiences_training_courses", "target_audiences"
  add_foreign_key "target_audiences_training_courses", "training_courses"
end
