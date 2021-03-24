class RemoveNumberFromParks < ActiveRecord::Migration[6.0]
  def change
    remove_column :parks, :number, :integer
  end
end
