class AddTesterAndDeviceInLot < ActiveRecord::Migration
  def change
    add_column :lots, :tester, :string
    add_column :lots, :device, :string
  end
end
