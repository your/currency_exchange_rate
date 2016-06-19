namespace :currency do

  task update_rates: :environment do
    Currency.update_rates
  end

end
