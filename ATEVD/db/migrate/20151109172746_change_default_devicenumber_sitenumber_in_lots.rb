class ChangeDefaultDevicenumberSitenumberInLots < ActiveRecord::Migration
  def change
    change_column_default :lots, :total_device_count, 2000
    change_column_default :lots, :site_number, 4
  end
end
