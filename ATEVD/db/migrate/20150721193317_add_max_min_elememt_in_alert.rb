class AddMaxMinElememtInAlert < ActiveRecord::Migration
  def change
    add_column :alerts, :max_element, :string
    add_column :alerts, :min_element, :string
  end
end
