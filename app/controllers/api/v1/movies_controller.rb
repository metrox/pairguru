class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all
    render json: MovieSerializer.new(@movies).serialized_json
  end

  def show
    @movie = Movie.find(params[:id])
    render json: MovieSerializer.new(@movie).serialized_json
  end
end
