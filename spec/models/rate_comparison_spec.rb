require 'rails_helper'

RSpec.describe RateComparison, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.create(:rate_comparison)).to be_valid
  end

  it { is_expected.to belong_to(:currency_one).class_name('Currency') }
  it { is_expected.to belong_to(:currency_two).class_name('Currency') }

  it { is_expected.to have_many :trades }

  [:currency_one, :currency_two].each do |att|
    it { is_expected.to validate_presence_of(att) }
  end

  it 'it does not save duplicates' do
    currency_one = FactoryGirl.create(:currency)
    currency_two = FactoryGirl.create(:currency)
    FactoryGirl.create(:rate_comparison, currency_one: currency_one, currency_two: currency_two)
    FactoryGirl.build(:rate_comparison, currency_one: currency_one, currency_two: currency_two).save
    expect(RateComparison.all.count).to eq(1)
  end

  it 'calculates the exchange rate correctly' do
    currency_one = FactoryGirl.build(:currency, rate: 1)
    currency_two = FactoryGirl.build(:currency, rate: 2)
    rate_comparison = RateComparison.new(currency_one: currency_one, currency_two: currency_two)
    expect(rate_comparison.exchange_rate).to eq(0.5)
  end

end

