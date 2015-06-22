class Search
  STORES_ADAPTERS = {
    google_play: Searchers::GooglePlayWorker,
    apple_store: Searchers::AppStoreWorker
  }

  def initialize(args)
    @query = args[:query]
    @requested_stores = args.select {|k, v| !(STORES_ADAPTERS[k.to_sym].nil? || v.to_i.zero?) }.keys
  end

  def perform
    Parallel.map(@requested_stores) do |store|
      STORES_ADAPTERS[store.to_sym].new(@query).get_results.map { |r| r.update store: store }
    end.flatten
  end
end
