require 'rails_helper'

RSpec.describe Currency, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:currency)).to be_valid
  end

  it { is_expected.to validate_presence_of(:iso_code) }

  it { is_expected.to validate_presence_of(:rate) }

  it 'updates the rates sucessfully' do
    Currency.update_rates
    expect(Currency.all.count > 0).to be_truthy
  end

end