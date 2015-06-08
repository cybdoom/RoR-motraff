class QuicksController < ApplicationController
  def show
  end

  def create
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
end
