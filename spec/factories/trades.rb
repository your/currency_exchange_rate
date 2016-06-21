FactoryGirl.define do
  factory :trade do
    rate_comparison
    direction Trade::DIRECTIONS.sample
    enter_rate 1.0
    exit_rate nil
    interest_rate Trade::INTEREST_RATES.sample
    closed_at nil
  end
end
