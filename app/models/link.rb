class Link
  include Mongoid::Document

  field :code, type: String
  field :button, type: String
  field :link, type: String

  embeds_many :apps

  belongs_to :user
end
