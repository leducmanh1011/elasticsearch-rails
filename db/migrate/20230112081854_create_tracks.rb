class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.integer :album_id
      t.integer :genre_id
      t.string :composer
      t.date :realease_date
      t.integer :seconds

      t.timestamps
    end
  end
end
