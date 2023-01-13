class AddFieldsToTrack < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :email, :string
  end
end
