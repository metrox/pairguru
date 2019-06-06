require "rails_helper"

describe "Top commentators", type: :request do
  it "properly renders top 10 commentators" do
    user0 = create(:user, email: "user0@example.com")
    create_list(:comment, 20, user: user0, created_at: 8.days.ago)

    12.times do |i|
      user = create(:user, email: "user#{i+1}@example.com")
      i.times { create(:comment, user: user) }
    end
    visit "/top_commentators"

    expect(all(".top_commentator").count).to eq(10)

    expect(page).not_to have_text("user0@example.com")

    all(".top_commentator").each_with_index do |commentator, index|
      expect(commentator).to have_text("user#{12 - index}@example.com")
    end
  end
end
