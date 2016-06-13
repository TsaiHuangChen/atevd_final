class ChangeDeviceTypeInLot < ActiveRecord::Migration
  def change

    change_column :lots, :device, :integer
  end
end
