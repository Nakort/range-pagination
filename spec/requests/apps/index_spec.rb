require 'rails_helper'

RSpec.describe "/apps", :type => :request do
  
  before(:all) do
    201.times.map { |i| App.create(name: "my-app-#{i}") }
  end

  let(:headers) {
    {
      "Range" => range_header
    }
  }

  let(:range_header) {
    "name ]my-app-1..my-app-200; max=10, order=asc"
  }

  let(:pagination_range) {
    PaginationRange.parse(range_header)
  }

  let(:paginable_scope) {
    PaginableScope.new(App.all, pagination_range)
  }

  let(:json_response) {
    JSON.parse(response.body)
  }

  it "should return a successful response" do
    get "/apps", headers: headers
    expect(response.status).to eq(200)
  end

  it "should return the correct number of objects" do
    get "/apps", headers: headers
    expect(json_response.size).to eq(10)
  end

  it "should return the content range in the headers" do
    get "/apps", headers: headers
    expect(response.headers["Content-Range"]).to_not be_nil
    expect(response.headers["Content-Range"]).to eq(paginable_scope.content_range.to_header)
  end

  it "should return the next range in the headers" do
    get "/apps", headers: headers
    expect(response.headers["Next-Range"]).to_not be_nil
    expect(response.headers["Next-Range"]).to eq(paginable_scope.next_range.to_header)
  end
end

