class RemoveProjectUrlFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :project_url
  end
end
