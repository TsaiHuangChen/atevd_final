class AddLotReferenceInAlerts < ActiveRecord::Migration
  def change
    add_reference :alerts, :lot, index: true, foreign_key: true
  end
end
