class User < ApplicationRecord

  has_secure_password

  has_one :user_detail
  has_many :stats
  has_and_belongs_to_many :followers

  def as_json(options={})
    super(only: [:id,:username, :email])
  end
end
