class AppsController < ApplicationController

  after_action  :set_pagination_headers

  def index
    render json: collection
  end

  private

  def range
    @range ||= PaginationRange.new(request.headers['Range'])
  end


  def set_pagination_headers

  end

  def collection
    PaginableScope.new(App.all, range)
  end
end
