class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.string :name
      t.boolean :status
      t.timestamps null: false
    end
  end
end
