require 'rails_helper'

RSpec.describe Currency, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:currency)).to be_valid
  end

  it { is_expected.to validate_presence_of(:iso_code) }

  it { is_expected.to validate_presence_of(:rate) }

  before do
    @existing_currencies = FactoryGirl.create_list(:currency, 3)
  end

  it 'updates the rates sucessfully' do
    expect { Currency.update_rates }.to change { @existing_currencies.map(&:reload).map(&:updated_at) }
  end
end
