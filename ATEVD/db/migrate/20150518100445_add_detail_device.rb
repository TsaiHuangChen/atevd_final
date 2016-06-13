class AddDetailDevice < ActiveRecord::Migration
  def change
    add_column :devices, :en_site_diff, :boolean
    add_column :devices, :window_1, :integer
  end
end
