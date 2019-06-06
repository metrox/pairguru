class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all
    render json: @movies, include: :genre, filter_genre: filter_genre
  end

  def show
    @movie = Movie.find(params[:id])
    render json: @movie, include: :genre, filter_genre: filter_genre
  end

  private

  def filter_genre
    params[:filter] && params[:filter][:genre] == "true"
  end
end
