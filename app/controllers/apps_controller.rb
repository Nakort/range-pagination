class AppsController < ApplicationController

  def index
    render json: collection
  end

  private

  def collection
    App.all
  end
end
