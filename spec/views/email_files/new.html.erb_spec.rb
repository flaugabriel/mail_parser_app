require 'rails_helper'

RSpec.describe "email_files/new", type: :view do
  before(:each) do
    assign(:email_file, EmailFile.new(
      original_filename: "MyString",
      source: "MyString",
      processed: false
    ))
  end

  it "renders new email_file form" do
    render

    assert_select "form[action=?][method=?]", email_files_path, "post" do

      assert_select "input[name=?]", "email_file[original_filename]"

      assert_select "input[name=?]", "email_file[source]"

      assert_select "input[name=?]", "email_file[processed]"
    end
  end
end
