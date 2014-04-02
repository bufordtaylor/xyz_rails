class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :category
      t.boolean :available, default: false
      
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :events, :name, name: "events_idx_name"
    add_index :events, [:latitude, :longitude, :available, :category], name: "events_idx_latitude_longitude_available_category"
  end
end
