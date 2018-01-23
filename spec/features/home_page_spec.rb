# spec spec/features/home_page_spec.rb
require 'rails_helper'

RSpec.describe "Home Page" do
  it "should return Rails default Home Page text" do
    visit root_url
    expect(page).to have_content "Pages#home"
  end
end
