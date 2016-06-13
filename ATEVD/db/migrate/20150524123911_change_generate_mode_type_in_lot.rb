class ChangeGenerateModeTypeInLot < ActiveRecord::Migration
  def change
    remove_column :lots, :generate_mode
    add_column :lots, :generate_mode, :integer
    #1: normal  2.Cliff  3. Site difference
  end
end
