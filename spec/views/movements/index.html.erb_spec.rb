require 'rails_helper'

RSpec.describe "movements/index", type: :view do
  before(:each) do
    assign(:movements, [
      Movement.create!(),
      Movement.create!()
    ])
  end

  it "renders a list of movements" do
    render
  end
end
