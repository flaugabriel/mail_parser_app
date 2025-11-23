require 'rails_helper'

RSpec.describe "email_files/show", type: :view do
  before(:each) do
    assign(:email_file, EmailFile.create!(
      original_filename: "Original Filename",
      source: "Source",
      processed: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Original Filename/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/false/)
  end
end
