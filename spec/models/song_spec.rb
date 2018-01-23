require 'rails_helper'

RSpec.describe Song, type: :model do
  describe 'title' do
    # Shoulda Matcher style :
    # it { is_expected.to validate_presence_of(:title) }

    it ", should validate presence of" do
      song = Song.new
      expect(song.valid?).to be false
    end
  end

end
