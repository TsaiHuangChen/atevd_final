class AddDetectionFlagInLot < ActiveRecord::Migration
  def change
    add_column :lots, :site_difference_detected, :boolean, :default => false
    add_column :lots, :continuously_failure_detected, :boolean, :default => false
    add_column :lots, :time_variance_detected, :boolean, :default => false
    add_column :lots, :different_tester_variance_detected, :boolean, :default => false
  end
end
