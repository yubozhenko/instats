class Stat < ApplicationRecord
  has_and_belongs_to_many :followers
  has_many :updates
end