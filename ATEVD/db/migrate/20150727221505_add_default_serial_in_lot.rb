class AddDefaultSerialInLot < ActiveRecord::Migration
  def change
    change_column :data, :serial, :integer,  :default => 0
  end
end
