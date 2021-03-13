class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      with_options null: false do
        t.string :vehicle_type
        t.string :city
        t.integer :class_number
        t.string :registration_type
        t.integer :designated_number
      end
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
