class Track < ApplicationRecord
  belongs_to :album
  belongs_to :genre

  update_index("tracks") { self }
end
