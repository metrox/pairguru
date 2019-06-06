require "rails_helper"

describe "Comments requests", type: :request do
  before(:each) do
    stub_request(:get, "https://pairguru-api.herokuapp.com/api/v1/movies/Deadpool").
       with(
         headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
         }).
       to_return(
        status: 200,
        body: {
          data: {
            id: "6",
            type: "movie",
            attributes: {
              title: "Godfather",
              plot: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
              rating: 9.2,
              poster:"/godfather.jpg"
            }
          }
        }.to_json,
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'Content-Type'=>'application/json'
          }
        )
  end

  context "#index" do
    let!(:movie) { create(:movie, title: "Deadpool") }
    let!(:johns_comment) { create(:comment, movie: movie, commenter: "John", body: "Hi there!") }
    let!(:alexs_comment) { create(:comment, movie: movie, commenter: "Alex", body: "Hello!") }

    it "displays right page and comments" do
      visit "/movies/1"
      expect(page).to have_text("Deadpool")

      expect(all(".comment").count).to eq(2)
      john_comment = all(".comment").first
      alex_second = all(".comment").last

      expect(john_comment).to have_text("Commenter: John")
      expect(john_comment).to have_text("Comment: Hi there!")

      expect(alex_second).to have_text("Commenter: Alex")
      expect(alex_second).to have_text("Comment: Hello!")
    end
  end

  context "#create" do
    let!(:movie) { create(:movie, title: "Deadpool") }

    it "adds a comment" do
      login
      visit "/movies/1"

      expect(page).to have_text("Deadpool")

      expect(page).not_to have_text("Commenter: John")
      expect(page).not_to have_text("Comment: MyComment")
      fill_in "comment[body]", with: "MyComment"
      click_on "Create Comment"

      expect(page).to have_text("Commenter: John")
      expect(page).to have_text("Comment: MyComment")
    end

    it "prohibit from having multiple comments" do
      add_a_comment

      fill_in "comment[body]", with: "My next comment"
      click_on "Create Comment"

      expect(page).not_to have_text("Comment: My next comment")
      expect(page).to have_text("User has already one comment")
    end
  end

  context "#destroy" do
    let!(:movie) { create(:movie, title: "Deadpool") }

    it "allows user to destroy comment" do
      add_a_comment

      expect(page).to have_text("Comment: MyComment")
      click_on "Destroy Comment"
      expect(page).not_to have_text("Comment: MyComment")
    end
  end

  def login
    email = "jon.snow@nightwatch.co"
    password = "password"
    create(:user, email: email, password: password, name: "John")

    visit '/users/sign_in'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
  end

  def add_a_comment
    login
    visit "/movies/1"

    fill_in "comment[body]", with: "MyComment"
    click_on "Create Comment"
  end
end
