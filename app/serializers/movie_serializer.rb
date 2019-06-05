class MovieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title
  belongs_to :genre, if: Proc.new { |_, params| params && params[:genre] == "true" }
end
