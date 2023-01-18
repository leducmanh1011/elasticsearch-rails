class AddFieldToTrack < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :name_en, :string
    add_column :tracks, :name_ja, :string

    remove_column :tracks, :name
  end
end
