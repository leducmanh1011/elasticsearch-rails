class Artist < ApplicationRecord
  has_many :albums

  enum gender: {male: 0, female: 1}
end
