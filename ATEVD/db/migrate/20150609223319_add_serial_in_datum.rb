class AddSerialInDatum < ActiveRecord::Migration
  def change
    add_column :data, :serial, :integer
  end
end
