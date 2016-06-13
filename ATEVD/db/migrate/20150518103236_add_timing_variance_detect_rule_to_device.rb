class AddTimingVarianceDetectRuleToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :time_variance_detect_enable, :boolean
    add_column :devices, :time_variance_detect_window_small, :integer
    add_column :devices, :time_variance_detect_window_large, :integer
    add_column :devices, :time_variance_detect_threshold, :float
  end
end
