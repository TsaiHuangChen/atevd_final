class AddBinInData < ActiveRecord::Migration
  def change
    add_column :data, :bin, :integer
  end
end
