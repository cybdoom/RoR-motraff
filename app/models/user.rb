class User
  include Mongoid::Document

  field :email, type: String

  has_many :links

  validates :email, uniqueness: true, presence: true, email: true
end
