require "rails_helper"

describe Api::V1::MoviesController do
  let!(:movie_godfather) { create(:movie, id: 1, title: "Godfather") }
  let!(:movie_deadpool) { create(:movie, id: 2, title: "Deadpool") }

  let(:godfather_json) {
    {
      id: "1",
      type: "movie",
      attributes: {
        title: "Godfather"
      }
    }
  }

  let(:deadpool_json) {
    {
      id: "2",
      type: "movie",
      attributes: {
        title: "Deadpool"
      }
    }
  }

  describe "GET #index" do
    it "displays all movies" do
      get :index

      expected_response = {
        data: [godfather_json, deadpool_json]
      }
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  describe "GET #show" do
    it "shows proper movie" do
      get :show, params: { id: 2 }

      expected_response = {
        data: deadpool_json
      }
      expect(response.body).to eq(expected_response.to_json)
    end
  end
end
