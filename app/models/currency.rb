class Currency < ActiveRecord::Base
  validates_presence_of :iso_code, :rate

  def self.update_rates
    HTTParty.get('http://api.fixer.io/latest')['rates'].each do |currency|
      ic, rate = currency.first, currency.second
      currency = Currency.where(iso_code: ic).first_or_create!(rate: rate)
      currency.touch # update timestamps
    end
  end

end