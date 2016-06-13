class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|

      t.timestamps null: false
    end
  end
end
