class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :course, foreign_key: true
      t.string :name
      t.string :grade
      t.string :project_url

      t.timestamps
    end
  end
end
