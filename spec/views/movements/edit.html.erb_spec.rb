require 'rails_helper'

RSpec.describe "movements/edit", type: :view do
  before(:each) do
    @movement = assign(:movement, Movement.create!())
  end

  it "renders the edit movement form" do
    render

    assert_select "form[action=?][method=?]", movement_path(@movement), "post" do
    end
  end
end
