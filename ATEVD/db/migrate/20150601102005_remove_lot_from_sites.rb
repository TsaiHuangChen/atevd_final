class RemoveLotFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :site_lot
    add_reference :sites, :lot, index: true, foreign_key: true
  end
end
