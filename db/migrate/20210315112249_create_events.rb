class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      with_options null: false do
        t.datetime :start_date
        t.datetime :end_date
        t.text :memo
      end
      t.boolean :cancel_flag, default: false, null: false
      t.references :park, foreign_key: true
      t.references :user, foreign_key: true
      t.references :car , foreign_key: true
      t.timestamps
    end
  end
end
