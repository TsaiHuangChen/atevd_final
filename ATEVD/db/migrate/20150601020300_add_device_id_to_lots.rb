class AddDeviceIdToLots < ActiveRecord::Migration
  def change
    add_reference :lots, :device, index: true, foreign_key: true
  end
end
