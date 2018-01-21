require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe 'name' do
    it "should validate presence of" do
      artist = Artist.new
      expect(artist.valid?).to be_false
    end
  end
end
