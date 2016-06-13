class ChangeDataTypeInDevices < ActiveRecord::Migration
  def change
    change_column :devices, :site_difference_detect_threshold, :decimal
  end
end
