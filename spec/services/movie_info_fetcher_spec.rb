require "rails_helper"
require "webmock/rspec"

describe MovieInfoFetcher do
  let(:expected_url) { "https://pairguru-api.herokuapp.com/api/v1/movies/Godfather" }
  let(:response_json) {
    {
      data: {
        id: "6",
        type: "movie",
        attributes: {
          title: "Godfather",
          plot: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
          rating: 9.2,
          poster:"/godfather.jpg"
        }
      }
    }.to_json
  }

  it "sends proper get request" do
    stub_request(:get, expected_url).
      to_return(
        headers: {"Content-Type" => "application/json"},
        body: response_json
      )
    expect(described_class.new("Godfather").call.to_json).to eq(response_json)
  end
end
