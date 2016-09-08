class AddFeatureDurationInDaysToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :feature_duration_in_days, :integer, null: false, default: 10
  end
end
