class AddCliffParameterInLot < ActiveRecord::Migration
  def change
    add_column :lots, :cliff_number, :integer
    add_column :lots, :first_region_yield, :float
    add_column :lots, :second_region_yield, :float
  end
end
