class AddBasicYieldInLot < ActiveRecord::Migration
  def change
    add_column :lots, :basic_yield, :float
  end
end
