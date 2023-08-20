class CreateWeather < ActiveRecord::Migration[6.0]
  def change
    create_table :weathers do |t|
      t.date :date
      t.float :lat
      t.float :lon
      t.string :city
      t.string :state
      t.json :temperatures
    end
  end
end
