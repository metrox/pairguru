class TopCommentatorsController < ApplicationController
  def index
    @commentators = top_commentators_query
  end

  private

  def top_commentators_query
    Comment.where("created_at >= ?", 7.days.ago).group(:user).order("count(comments.user_id) desc").limit(10).count
  end
end
