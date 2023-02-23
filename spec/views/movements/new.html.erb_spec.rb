require 'rails_helper'

RSpec.describe "movements/new", type: :view do
  before(:each) do
    assign(:movement, Movement.new())
  end

  it "renders new movement form" do
    render

    assert_select "form[action=?][method=?]", movements_path, "post" do
    end
  end
end
