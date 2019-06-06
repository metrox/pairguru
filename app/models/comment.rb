class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  validates :user, uniqueness: { scope: :movie, message: "has already one comment" }
end
