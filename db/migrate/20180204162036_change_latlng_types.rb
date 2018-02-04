class ChangeLatlngTypes < ActiveRecord::Migration[5.1]
  def change
    change_column(:sightings, :latitude, :decimal, precision: 10, scale: 6)
    change_column(:sightings, :longitude, :decimal, precision: 10, scale: 6)

    add_index :sightings, :latitude
    add_index :sightings, :longitude
  end
end
