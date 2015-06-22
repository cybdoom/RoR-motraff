class QuicksController < ApplicationController
  def show
  end

  def create
    new_link = Link.new access_params
    new_link.apps = []
    apps_data = JSON.parse create_quick_link_params[:apps]
    apps_data.each do |app_data|
      attrs = apps_data.select {|k| k != 'store' }
      attrs['market'] = Hash[App::STORES.map.with_index.to_a][apps_data['store'].to_sym]
      new_link.apps.push App.new(app_data)
    end
    render json: { created: new_link.save }
  end

  def get_access
    res = {
      code: SecureRandom.hex(8),
      link: "http://motraff.io/#{SecureRandom.hex(16)}",
      button: "<img src='http://motraff.io/#{SecureRandom.hex(16)}.jpg'>"
    }

    render json: res
  end

  def search_apps
    render json: Search.new(search_apps_params).perform
  end

  private

  def search_apps_params
    params.require(:search).permit(:query, :google_play, :apple_store, :windows, :black_berry)
  end

  def create_quick_link_params
    params.permit(:code, :button, :link, :apps)
  end

  def access_params
    create_quick_link_params.select {|k| k != 'apps' }
  end

  def app_params
  end
end
