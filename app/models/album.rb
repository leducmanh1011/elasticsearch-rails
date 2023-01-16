class Album < ApplicationRecord
  belongs_to :artist
  has_many :tracks

  update_index("tracks") { tracks }
end
