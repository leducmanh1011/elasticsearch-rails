class Genre < ApplicationRecord
  has_many :tracks

  update_index("tracks") { tracks }
end
