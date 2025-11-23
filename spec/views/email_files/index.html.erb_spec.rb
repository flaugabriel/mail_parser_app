require 'rails_helper'

RSpec.describe "email_files/index", type: :view do
  before(:each) do
    assign(:email_files, [
      EmailFile.create!(
        original_filename: "Original Filename",
        source: "Source",
        processed: false
      ),
      EmailFile.create!(
        original_filename: "Original Filename",
        source: "Source",
        processed: false
      )
    ])
  end

  it "renders a list of email_files" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Original Filename".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Source".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
