class RenamePrefectureCodeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :prefecture_code, :prefecture_id
  end
end
