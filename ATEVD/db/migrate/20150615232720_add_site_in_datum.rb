class AddSiteInDatum < ActiveRecord::Migration
  def change
    add_column :data, :site, :integer
  end
end
