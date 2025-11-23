require 'rails_helper'

RSpec.describe "email_files/edit", type: :view do
  let(:email_file) {
    EmailFile.create!(
      original_filename: "MyString",
      source: "MyString",
      processed: false
    )
  }

  before(:each) do
    assign(:email_file, email_file)
  end

  it "renders the edit email_file form" do
    render

    assert_select "form[action=?][method=?]", email_file_path(email_file), "post" do

      assert_select "input[name=?]", "email_file[original_filename]"

      assert_select "input[name=?]", "email_file[source]"

      assert_select "input[name=?]", "email_file[processed]"
    end
  end
end
