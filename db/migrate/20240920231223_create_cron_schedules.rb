class CreateCronSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :cron_schedules do |t|
      t.references :service, null: false, foreign_key: true
      t.string :schedule, null: false

      t.timestamps
    end
  end
end
