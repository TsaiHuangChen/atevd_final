class AddContinuouslyFailureDetectRuleToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :continuously_failure_detect_enable, :boolean
    add_column :devices, :continuously_failure_detect_threshold, :integer
  end
end
