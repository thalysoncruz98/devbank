require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
