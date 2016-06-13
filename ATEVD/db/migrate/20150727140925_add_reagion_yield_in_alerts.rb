class AddReagionYieldInAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :region_1_yield, :float
    add_column :alerts, :region_2_yield, :float
  end
end
