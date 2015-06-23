class QuicksController < ApplicationController
  def show
  end

  def create
    create_params = create_link_params
    apps_data = JSON.parse create_params.delete(:apps)
    @new_link = Link.new create_params
    @new_link.apps = apps_data.map {|app_data| App.new app_data }
    saved = @new_link.save
    response_object = if saved
      {
        message: 'Your link was successfully saved',
        link: @new_link.private_link
      }
    else
      {
        message: 'Failed to save Your link! Please, try again',
        errors: @new_link.errors.messages
      }
    end
    response_status = saved ? :ok : :bad_request

    render json: response_object, status: response_status
  end

  def get_access
    @new_link = Link.new
    response_object = {
      private_code: @new_link.private_code,
      public_code: @new_link.public_code,
      public_link: @new_link.public_link,
      button: @new_link.button
    }

    render json: response_object
  end

  def search
  end

  def search_apps
    render json: Search.new(search_apps_params).perform
  end

  private

  def search_apps_params
    params.require(:search).permit(:query, :google_play, :apple_store, :windows, :black_berry)
  end

  def create_link_params

    params.require(:link).permit(:private_code, :public_code, :apps)
  end
end
