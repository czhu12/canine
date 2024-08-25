class CreateDeployments < ActiveRecord::Migration[7.1]
  def change
    create_table :deployments do |t|
      t.references :project, null: false, foreign_key: true
      t.references :build, null: false, foreign_key: true

      t.timestamps
    end
  end
end
