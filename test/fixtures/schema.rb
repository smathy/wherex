ActiveRecord::Schema.define do

  create_table "users", :force => true do |t|
    t.string   "zipcode"
    t.timestamps null: false
  end

  create_table "students", :force => true do |t|
    t.string "name"
    t.timestamps null: false
  end

  create_table "products", :force => true do |t|
    t.string "code"
    t.timestamps null: false
  end
end


