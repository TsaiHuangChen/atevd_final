class CreateSites < ActiveRecord::Migration
  def change

    create_table :sites do |t|
      t.string :site_lot
      t.integer :site_serial
      t.boolean :site_enable
      t.float :site_yield

      t.timestamps null: false
    end

  end
end
