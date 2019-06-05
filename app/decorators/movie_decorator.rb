class MovieDecorator < Draper::Decorator
  delegate_all

  def cover
    return fake_cover if context.empty?
    "https://pairguru-api.herokuapp.com" + context.dig(:data, :attributes, :poster)
  end

  def description
    return object.description if context.empty?
    context.dig(:data, :attributes, :plot)
  end

  def rating
    context.dig(:data, :attributes, :rating) || "N/A"
  end

  private

  def fake_cover
    "http://lorempixel.com/100/150/" +
      %w[abstract nightlife transport].sample +
      "?a=" + SecureRandom.uuid
  end
end
