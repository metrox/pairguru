class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = fetch_all_movies
  end

  def show
    @movie = fetch_movie
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  private

  def fetch_movie
    movie = Movie.find(params[:id])
    fetched_data = MovieInfoFetcher.new(movie.title).call
    movie.decorate(context: fetched_data)
  end

  def fetch_all_movies
    all = Movie.all.map do |movie|
      fetched_data = MovieInfoFetcher.new(movie.title).call
      movie.decorate(context: fetched_data)
    end
  end
end
