class AddRendingStopToParks < ActiveRecord::Migration[6.0]
  def change
    add_column :parks, :rending_stop, :boolean
  end
end
