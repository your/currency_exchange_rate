require 'rails_helper'

RSpec.describe Trade, type: :model do
  before do
    FactoryGirl.create(:balance, amount: 10_000)
  end

  it { is_expected.to validate_inclusion_of(:direction).in_array(Trade::DIRECTIONS) }
  it { is_expected.to validate_inclusion_of(:interest_rate).in_array(Trade::INTEREST_RATES) }

  it { is_expected.to belong_to :rate_comparison }

  [:direction, :rate_comparison_id, :enter_rate, :interest_rate].each do |attribute|
    it { is_expected.to validate_presence_of attribute }
  end

  it { is_expected.to validate_uniqueness_of(:rate_comparison_id).scoped_to(:closed_at) }

  describe "#callbacks" do
    context "create" do
      context "when funds are sufficient" do
        it "subtracts from balance accordingly" do
          expect{FactoryGirl.create(:trade)}.to change{Balance.last.reload.amount}.to(9_900)
        end
      end

      context "when funds are insufficient" do
        before do
          FactoryGirl.create(:balance, amount: 99)
        end

        it "will raise an error" do
          expect{FactoryGirl.create(:trade)}.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Trade Insufficient Funds')
        end
      end
    end
  end

  describe "#outcome" do
    before do
      @currency_1 = FactoryGirl.create(:currency, iso_code: 'EUR', rate: 2.000)
      @currency_2 = FactoryGirl.create(:currency, iso_code: 'GBP', rate: 1.000)
      @currency_3 = FactoryGirl.create(:currency, iso_code: 'USD', rate: 4.000)

      @rate_comparison_1 = FactoryGirl.create(:rate_comparison, currency_one: @currency_1, currency_two: @currency_2)
      @rate_comparison_2 = FactoryGirl.create(:rate_comparison, currency_one: @currency_2, currency_two: @currency_1)
      @rate_comparison_3 = FactoryGirl.create(:rate_comparison, currency_one: @currency_1, currency_two: @currency_3)
      @rate_comparison_4 = FactoryGirl.create(:rate_comparison, currency_one: @currency_3, currency_two: @currency_1)

      @trade_1 = FactoryGirl.create(:trade, direction: :long, rate_comparison: @rate_comparison_1, interest_rate: 0.2, enter_rate: 1.000)
      @trade_2 = FactoryGirl.create(:trade, direction: :long, rate_comparison: @rate_comparison_2, interest_rate: 0.2, enter_rate: 1.000)
      @trade_3 = FactoryGirl.create(:trade, direction: :short, rate_comparison: @rate_comparison_3, interest_rate: 0.2, enter_rate: 1.000)
      @trade_4 = FactoryGirl.create(:trade, direction: :short, rate_comparison: @rate_comparison_4, interest_rate: 0.2, enter_rate: 1.000)
    end

    it { expect(@trade_1.outcome).to eq :gain }
    it { expect(@trade_2.outcome).to eq :loss }
    it { expect(@trade_3.outcome).to eq :loss }
    it { expect(@trade_4.outcome).to eq :gain }
  end

  describe "#close!" do
    before do
      @trade = FactoryGirl.create(:trade)
    end

    it "closes a trade" do
      expect{@trade.close!}.to change{@trade.reload.closed_at}.from(nil)
      expect{@trade.close!}.to change{@trade.reload.updated_at}
    end

    it "creates a new balance" do
      expect{@trade.close!}.to change{Balance.count}.by(1)
    end

    it "assesses the balance amount accordingly to the interest rate" do
      @trade.close!
      expect(Balance.last.amount).to eq (Balance.last(2).first.amount + (100 * @trade.interest_rate))
    end
  end

  describe "#update_current_interest_value!" do
    before do
      @currency_1 = FactoryGirl.create(:currency, iso_code: 'EUR', rate: 2.000)
      @currency_2 = FactoryGirl.create(:currency, iso_code: 'GBP', rate: 1.000)
      @currency_3 = FactoryGirl.create(:currency, iso_code: 'USD', rate: 4.000)

      @rate_comparison_1 = FactoryGirl.create(:rate_comparison, currency_one: @currency_1, currency_two: @currency_2)
      @rate_comparison_2 = FactoryGirl.create(:rate_comparison, currency_one: @currency_1, currency_two: @currency_3)

      @positive_trade = FactoryGirl.create(:trade, direction: :long, rate_comparison: @rate_comparison_1, interest_rate: 0.2, enter_rate: 1.000)
      @negative_trade = FactoryGirl.create(:trade, direction: :short, rate_comparison: @rate_comparison_2, interest_rate: 0.2, enter_rate: 2.000)
    end

    it "can update the current interest value" do
      expect{@positive_trade.update_current_interest_value!}
        .to change{@positive_trade.reload.interest_value}
          .to(20)
      expect{@negative_trade.update_current_interest_value!}
        .to change{@negative_trade.reload.interest_value}
          .to(-30)
    end
  end
end
