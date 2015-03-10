class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :short_name
      t.string :university
      t.string :address

      t.timestamps null: false
    end
  end
end
