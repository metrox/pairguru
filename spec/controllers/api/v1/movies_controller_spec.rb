require "rails_helper"

describe Api::V1::MoviesController do
  let(:genre) { create(:genre, id: 3, name: "Action") }
  let!(:movie_godfather) { create(:movie, id: 1, title: "Godfather", genre: genre) }
  let!(:movie_deadpool) { create(:movie, id: 2, title: "Deadpool", genre: genre) }
  let(:godfather_without_filter_json) {
    {
      id: "1",
      type: "movie",
      attributes: {
        title: "Godfather"
      },
      relationships: {}
    }
  }

  let(:deadpool_without_filter_json) {
    {
      id: "2",
      type: "movie",
      attributes: {
        title: "Deadpool"
      },
      relationships: {}
    }
  }
  let(:godfather_with_filter_json) {
    {
      id: "1",
      type: "movie",
      attributes: {
        title: "Godfather"
      },
      relationships: {
        genre: {
          data: {
            id: "3",
            type: "genre"
          }
        }
      }
    }
  }

  let(:deadpool_with_filter_json) {
    {
      id: "2",
      type: "movie",
      attributes: {
        title: "Deadpool"
      },
      relationships: {
        genre: {
          data: {
            id: "3",
            type: "genre"
          }
        }
      }
    }
  }
  let(:genre_json) {
    {
      id: "3",
      type: "genre",
      attributes: {
        name: "Action"
      },
    }
  }
  let(:relationships) { {} }

  describe "GET #index" do
    context "without genre" do
      it "displays all movies" do
        get :index

        expected_response = {
          data: [godfather_without_filter_json, deadpool_without_filter_json],
          included: []
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "with genre" do
      it "displays all movies" do
        get :index, params: { "filter[genre]": true }

        expected_response = {
          data: [godfather_with_filter_json, deadpool_with_filter_json],
          included: [genre_json]
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe "GET #show" do
    context "without genre" do
      it "shows proper movie" do
        get :show, params: { id: 2 }

        expected_response = {
          data: deadpool_without_filter_json,
          included: []
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context "with genre" do
      it "shows proper movie" do
        get :show, params: { id: 2, "filter[genre]": true }

        expected_response = {
          data: deadpool_with_filter_json,
          included: [genre_json]
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end
end
