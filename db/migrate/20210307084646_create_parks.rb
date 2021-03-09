class CreateParks < ActiveRecord::Migration[6.0]
  def change
    create_table :parks do |t|

      with_options null: false do
        t.string :name
        t.integer :number
        t.string :postal_code
        t.integer :prefecture_code
        t.string :city
        t.string :street
        t.integer :unit_price
        t.datetime :start_time
        t.datetime :end_time
      end
      
      t.string :explosive
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
