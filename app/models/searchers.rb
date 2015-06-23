module Searchers
  class Worker
    attr_accessor :query

    def initialize(query)
      @query = query
    end

    def transformation
      {}
    end
    protected :transformation

    def do_query
      []
    end
    protected :do_query

    def get_results
      do_query.first(4).map do |r|
        json = r.as_json
        transformation.inject({}) do |h,(k,v)|
          h.update k => json[v]
        end
      end
    end
  end

  class GooglePlayWorker < Worker
    def transformation
      {store_id: 'id', app_url: 'url', logo_url: 'logo_url', title: 'name', publisher: 'developer'}
    end

    def do_query
      GooglePlaySearch::Search.new.search query
    end
  end

  class AppStoreWorker < Worker
    def transformation
      {store_id: 'trackId', app_url: 'trackViewUrl', logo_url: 'artworkUrl60', title: 'trackName', publisher: 'sellerName'}
    end

    def do_query
      ITunesSearchAPI.search term: query, media: 'software'
    end
  end
end
