class AddUseStopToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :use_stop, :boolean
  end
end
