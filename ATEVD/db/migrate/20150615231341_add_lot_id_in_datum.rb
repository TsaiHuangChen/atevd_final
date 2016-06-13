class AddLotIdInDatum < ActiveRecord::Migration
  def change
    add_reference :data, :lot, index: true, foreign_key: true
  end
end
