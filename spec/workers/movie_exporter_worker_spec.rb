require "rails_helper"
require "sidekiq/testing"

describe MovieExporterWorker, type: :worker do
  let!(:user) { create(:user, email: "jon.snow@nightwatch.co") }

  it "changes queue size and properly sends email" do
    expect(ActionMailer::Base.deliveries).to be_empty
    expect {
      MovieExporterWorker.perform_async(user.id, "tmp/movies.csv")
    }.to change(MovieExporterWorker.jobs, :size).by(1)

    Sidekiq::Worker.drain_all

    expect(ActionMailer::Base.deliveries.count).to eq(1)
    mail = ActionMailer::Base.deliveries.first

    expect(mail.to).to eq([user.email])
    expect(mail.subject).to eq("Your export is ready")
  end
end
