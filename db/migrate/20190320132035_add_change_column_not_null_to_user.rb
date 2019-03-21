class AddChangeColumnNotNullToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :first_name, :string, :null => false
    change_column :users, :last_name, :string, :null => false
    change_column :users, :citizenid, :string, :null => false
    change_column :users, :instituteid, :string, :null => false
    change_column :users, :role_id, :bigint, :null => false
  end
end
