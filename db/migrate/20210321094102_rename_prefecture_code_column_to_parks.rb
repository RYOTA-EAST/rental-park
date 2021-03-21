class RenamePrefectureCodeColumnToParks < ActiveRecord::Migration[6.0]
  def change
    rename_column :parks, :prefecture_code, :prefecture_id
  end
end
