class App
  include Mongoid::Document

  STORES = [
    :google_play,  # 0
    :app_store,    # 1
    :windows,      # 2
    :black_berry   # 3
  ]

  embedded_in :link

  field :store_id, type: String
  field :app_url, type: String
  field :logo_url, type: String
  field :title, type: String
  field :store, type: Integer
  field :publisher, type: String

  validates :app_url, presence: true
  validates :title, presence: true, length: { minimum: 2, maximum: 256 }
  validates :store, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: STORES.size
  }

  def store= value
    if value.is_a? Fixnum
      super value
    else
      super Hash[STORES.map.with_index.to_a][value.to_sym]
    end
  end
end
