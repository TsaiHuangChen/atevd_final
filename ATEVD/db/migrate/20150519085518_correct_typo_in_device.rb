class CorrectTypoInDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :diffrent_tester_variance_detect_enable
    remove_column :devices, :diffrent_tester_variance_detect_window
    remove_column :devices, :diffrent_tester_variance_detect_threshold

    add_column :devices, :different_tester_variance_detect_enable, :boolean
    add_column :devices, :different_tester_variance_detect_window, :integer
    add_column :devices, :different_tester_variance_detect_threshold, :float
  end
end
