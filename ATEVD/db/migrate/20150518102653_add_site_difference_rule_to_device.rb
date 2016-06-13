class AddSiteDifferenceRuleToDevice < ActiveRecord::Migration
  def change
    #site difference detection rules
    add_column :devices, :site_difference_detect_enable, :boolean
    add_column :devices, :site_difference_detect_window, :integer
    add_column :devices, :site_defference_detect_threshold, :float
  end
end
