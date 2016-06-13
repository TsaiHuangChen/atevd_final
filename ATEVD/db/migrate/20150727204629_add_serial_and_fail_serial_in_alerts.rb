class AddSerialAndFailSerialInAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :detected_serial, :integer, :default => 0
    add_column :alerts, :continuously_fail_number, :integer , :default => 0
    add_column :alerts, :continuously_fail_bin, :integer, :default => 0
  end
end
