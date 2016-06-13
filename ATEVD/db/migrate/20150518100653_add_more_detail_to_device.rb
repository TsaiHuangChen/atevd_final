class AddMoreDetailToDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :en_site_diff
    remove_column :devices, :window_1
  end
end
