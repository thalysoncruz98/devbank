require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(),
      Account.create!()
    ])
  end

  it "renders a list of accounts" do
    render
  end
end
