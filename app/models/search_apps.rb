class SearchApps
  include ActiveModel::Model
  STORES_ADAPTERS = {
      google_play: {
          properties: %w(id url logo_url title:name publisher:developer),
          get_method: 'send'
      },
      apple_store: {
          properties: %w(id:trackId url:trackViewUrl logo_url:artworkUrl60 title:trackName publisher:sellerName),
          get_method: '[]'
      },
      windows: {},
      black_berry: {}
  }

  attr_accessor :query, *STORES_ADAPTERS.keys

  def google_play_search
    GooglePlaySearch::Search.new.search query
  end

  def apple_store_search
    ITunesSearchAPI.search term: query, media: 'software'
  end

  def search
    Parallel.map(STORES_ADAPTERS) do |store, options|
      pretty(store, options) if send(store).to_b
    end.compact.flatten
  end

  def pretty(store, options)
    properties = options[:properties].map {|str| str.split(':')}
    send("#{store}_search").first(4).map do |el|
      properties.map do |property|
        [property.first, el.send(options[:get_method], property.last)]
      end.push(['store', store.to_s]).to_h
    end
  end

end

