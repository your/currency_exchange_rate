class Trade < ActiveRecord::Base
  DIRECTIONS     = [:short, :long]
  INTEREST_RATES = [0.2, 0.4]

  belongs_to :rate_comparison

  validates_presence_of :direction
  validates_presence_of :rate_comparison_id
  validates_presence_of :enter_rate
  validates_presence_of :interest_rate

  validates_inclusion_of :direction, in: DIRECTIONS.map(&:to_s)
  validates_inclusion_of :interest_rate, in: INTEREST_RATES

  validates_uniqueness_of :rate_comparison_id, scope: [:closed_at], allow_blank: true

  validate :_funds_availability, if: -> { new_record? }
  validate :_update_eligibility

  before_create :_take_funds!

  def close!
    Balance.create!(amount: Balance.last.amount + _current_interest_value)
    update_columns(closed_at: DateTime.current, updated_at: DateTime.current)
  end

  def update_current_interest_value!
    update_columns(interest_value: _current_interest_value, updated_at: DateTime.current)
  end

  def positive?
    _direction_sign == 1
  end

  def negative?
    _direction_sign == -1
  end

  def gain?
    positive?
  end

  def loss?
    negative?
  end

  def outcome
    gain? ? :gain : :loss
  end

  private

    def _take_funds!
      Balance.create!(amount: Balance.last.amount - 100)
    end

    def _current_interest_value
      _direction_sign * _absolute_interest_value * _absolute_rate_diff
    end

    def _absolute_rate_diff
      (rate_comparison.exchange_rate - enter_rate).abs
    end

    def _funds_availability
      errors.add(:trade, "Insufficient Funds") unless _is_balance_enough?
    end

    def _update_eligibility
      errors.add(:trade, "Can't manually update an existing trade") unless new_record?
    end

    def _is_balance_enough?
      Balance.last.try(:amount).to_i - 100 > 0
    end

    def _direction_sign
      if rate_comparison.exchange_rate > enter_rate
        direction == :long ? -1 :  1
      else
        direction == :long ?  1 : -1
      end
    end

    def _absolute_interest_value
      100 * interest_rate
    end
end
