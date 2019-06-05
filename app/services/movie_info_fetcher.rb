class MovieInfoFetcher
  def initialize(title)
    @title = title
  end

  def call
    HTTParty.get(url).with_indifferent_access
  end

  private

  def url
    "https://pairguru-api.herokuapp.com/api/v1/movies/" + URI.encode(title)
  end

  attr_reader :title
end
