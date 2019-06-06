require "rails_helper"
require "sidekiq/testing"

describe MovieMailerWorker, type: :worker do
  let!(:user) { create(:user, email: "jon.snow@nightwatch.co") }
  let!(:movie) { create(:movie, title: "Godfather") }

  it "changes queue size and properly sends email" do
    expect(ActionMailer::Base.deliveries).to be_empty
    expect {
      MovieMailerWorker.perform_async(user.id, movie.id)
    }.to change(MovieMailerWorker.jobs, :size).by(1)

    Sidekiq::Worker.drain_all

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    mail = ActionMailer::Base.deliveries.first

    expect(mail.to).to eq([user.email])
    expect(mail.subject).to eq("Info about movie Godfather")
  end

end
