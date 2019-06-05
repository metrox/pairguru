class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all
    render json: MovieSerializer.new(@movies, additional_params).serialized_json
  end

  def show
    @movie = Movie.find(params[:id])
    render json: MovieSerializer.new(@movie, additional_params).serialized_json
  end

  private

  def additional_params
    {
      include: [:genre],
      params: {
        genre: params[:filter] ? params[:filter][:genre] : nil
      }
    }
  end
end
