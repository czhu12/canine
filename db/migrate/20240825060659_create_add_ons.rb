class CreateAddOns < ActiveRecord::Migration[7.1]
  def change
    create_table :add_ons do |t|
      t.references :cluster, null: false, foreign_key: true
      t.string :name, null: false
      t.string :helm_chart_url, null: false
      t.integer :status, null: false, default: 0
      t.jsonb :metadata, default: {}

      t.timestamps
    end
    add_index :add_ons, [:cluster_id, :name], unique: true
  end
end
