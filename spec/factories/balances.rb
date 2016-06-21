FactoryGirl.define do
  factory :balance do
    amount { rand(0..10_000) }
  end
end
