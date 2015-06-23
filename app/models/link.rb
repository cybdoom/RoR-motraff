class Link
  include Mongoid::Document

  after_initialize :generate_codes

  field :private_code, type: String
  field :public_code, type: String

  embeds_many :apps

  belongs_to :user

  def private_link
    @private_link ||= "http://quick.motraff.me/#{ self.private_code }"
  end

  def public_link
    @public_link ||= "http://motraff.io/#{ self.public_code }"
  end

  def button
    @public_button ||= "<img src=\"http://motraff.io/#{ self.public_code }.jpg\"/>"
  end

  def generate_codes
    self.private_code ||= SecureRandom.hex 8
    self.public_code  ||= SecureRandom.hex 16
  end
end
