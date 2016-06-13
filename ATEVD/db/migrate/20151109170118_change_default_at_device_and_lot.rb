class ChangeDefaultAtDeviceAndLot < ActiveRecord::Migration
  def change
    change_column_default :devices, :site_difference_detect_enable, true
    change_column_default :devices, :continuously_failure_detect_enable, true
    change_column_default :devices, :time_variance_detect_enable, true
    change_column_default :devices, :different_tester_variance_detect_enable, true
    change_column_default :sites, :site_enable, true
  end
end
