class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title
  belongs_to :genre, if: Proc.new { |params| @instance_options[:filter_genre] }
end
