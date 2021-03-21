class RemovePostalCodeFromParks < ActiveRecord::Migration[6.0]
  def change
    remove_column :parks, :postal_code, :string
  end
end
