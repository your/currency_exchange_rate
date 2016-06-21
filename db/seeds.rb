#Fetch complete list of updated currency/rates
Currency.update_rates

# Create random rates comparisons
10.times do |i|

  #Preventing duplicates
  begin
    currency_one, currency_two = Currency.offset(rand(Currency.count)).first(2)
  end until RateComparison.where(currency_one: currency_one, currency_two: currency_two).empty?

  RateComparison.create(currency_one: currency_one, currency_two: currency_two)

end