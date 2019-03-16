class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :role, foreign_key: true
    add_column :users, :citizenid, :string
    add_column :users, :instituteid, :string
  end
end
