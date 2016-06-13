class AddDiffAteVarianceDetectRuleToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :diffrent_tester_variance_detect_enable, :boolean
    add_column :devices, :diffrent_tester_variance_detect_window, :integer
    add_column :devices, :diffrent_tester_variance_detect_threshold, :float
  end
end
