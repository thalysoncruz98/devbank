require 'rails_helper'

RSpec.describe "movements/show", type: :view do
  before(:each) do
    @movement = assign(:movement, Movement.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
