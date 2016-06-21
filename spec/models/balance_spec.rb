require 'rails_helper'

RSpec.describe Balance, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:balance)).to be_valid
  end
end
