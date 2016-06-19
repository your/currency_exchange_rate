require 'faker'

FactoryGirl.define do

  factory :rate_comparison do
    currency_one { FactoryGirl.create(:currency) }
    currency_two { FactoryGirl.create(:currency) }
  end

end