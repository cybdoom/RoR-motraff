class QuickController < ApplicationController

  def search
  end

  def search_apps
    render json: SearchApps.new(search_apps_params).search
  end

  private

  def search_apps_params
    params.require(:search_apps).permit(:query, :google_play, :apple_store, :windows, :black_berry)
  end

end
