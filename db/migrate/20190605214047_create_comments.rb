class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :user, foreign_key: true
      t.references :movie, foreign_key: true
      t.timestamps

      t.index [:user_id, :movie_id], unique: true
    end
  end
end
