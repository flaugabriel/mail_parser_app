require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  it "existe e herda de ActionMailer::Base" do
    expect(ApplicationMailer).to be < ActionMailer::Base
  end
end
