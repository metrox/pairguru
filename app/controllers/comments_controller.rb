class CommentsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @comment = @movie.comments.create(comment_params)

    if @comment.persisted?
      redirect_to movie_path(@movie)
    else
      redirect_to movie_path(@movie), flash: { errors: @comment.errors.full_messages }
    end
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @comment = @movie.comments.find(params[:id])
    @comment.destroy
    redirect_to movie_path(@movie)
  end

  private
    def comment_params
      params.require(:comment).permit(:body).
        merge!(
          user_id: current_user.id,
          commenter: current_user.name
        )
    end
end
