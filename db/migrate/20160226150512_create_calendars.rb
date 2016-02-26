class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :calendar_id
      t.string :title
      t.integer :timecrowd_user_id

      t.timestamps null: false
    end
  end
end
