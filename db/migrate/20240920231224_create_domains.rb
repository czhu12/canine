class CreateDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :domains do |t|
      t.references :service, null: false, foreign_key: true
      t.string :domain_name, null: false

      t.timestamps
    end
  end
end