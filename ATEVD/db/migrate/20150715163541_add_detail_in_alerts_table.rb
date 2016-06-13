class AddDetailInAlertsTable < ActiveRecord::Migration
  def change
    add_column :alerts, :alerts_kind, :integer
    add_column :alerts, :fixed, :boolean, :default => false

  end
end
