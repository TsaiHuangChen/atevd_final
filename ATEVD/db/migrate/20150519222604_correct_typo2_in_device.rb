class CorrectTypo2InDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :site_defference_detect_threshold
    add_column :devices, :site_difference_detect_threshold, :float
  end
end
