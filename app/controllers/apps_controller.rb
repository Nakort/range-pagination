class AppsController < ApplicationController

  after_action  :set_pagination_headers

  def index
    render json: collection.all
  end

  private

  def range
    @range ||= PaginationRange.parse(request.headers['Range'])
  end

  def set_pagination_headers
    response.headers["Content-Range"] = collection.content_range.to_header 
    response.headers["Next-Range"]    = collection.next_range.to_header
  end

  def collection
    @collection ||= PaginableScope.new(App.all, range)
  end
end
