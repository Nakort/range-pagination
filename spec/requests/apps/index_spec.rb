require 'rails_helper'

RSpec.describe "/apps", :type => :request do
  
  let!(:apps) {
    10.times.map { |i| App.create(name: "my-app-#{i}") }
  }

  let(:headers) {
    {
      "Range" => "name ]my-app-001..my-app-999; max=10, order=asc"
    }
  }

  it "should return a 200 response" do
    get "/apps", headers: headers
    expect(response.status).to eq(200)
  end
end

