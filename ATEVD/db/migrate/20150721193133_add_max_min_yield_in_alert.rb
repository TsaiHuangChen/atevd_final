class AddMaxMinYieldInAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :max_yield, :float
    add_column :alerts, :min_yield, :float
  end
end
