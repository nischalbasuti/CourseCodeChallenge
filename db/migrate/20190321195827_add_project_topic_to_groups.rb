class AddProjectTopicToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :project_topic, :string
  end
end
