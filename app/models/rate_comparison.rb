class RateComparison < ActiveRecord::Base

  belongs_to :currency_one, class_name: 'Currency'
  belongs_to :currency_two, class_name: 'Currency'
  has_many :trades

  validates_presence_of :currency_one, :currency_two

  validates_uniqueness_of :currency_one, scope: :currency_two

  def exchange_rate
    #BigDecimal avoids rounding imprecisions on divisions, I also could've used the money gem
    (BigDecimal.new(currency_one.rate, 0) / BigDecimal.new(currency_two.rate, 0)).to_f.round(4)
  end

end