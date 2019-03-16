class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.references :user, foreign_key: true
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
