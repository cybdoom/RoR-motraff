class App
  include Mongoid::Document

  STORES = [
    :google_play, # = 0
    :app_store    # = 1
  ]

  embedded_in :link

  field :market_id, type: String
  field :url, type: String
  field :logo_url, type: String
  field :title, type: String
  field :market, type: Integer
  field :publisher, type: String

  validates :url, presence: true
  validates :title, presence: true, length: { minimum: 2, maximum: 256 }
  validates :market, inclusion: { in: STORES }
end
