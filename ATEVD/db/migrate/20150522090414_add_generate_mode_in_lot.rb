class AddGenerateModeInLot < ActiveRecord::Migration
  def change
    add_column :lots, :generate_mode, :string
  end
end
