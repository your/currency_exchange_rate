class CurrencyController < ActionController::Base

  def index
  end

  def manage_rate_comparisons
    @rate_comparison = RateComparison.new
  end

  def add_rate_comparison
    currency_one, currency_two = rate_comparison_params.map do |param, id| Currency.find(id) end
    RateComparison.new(currency_one: currency_one, currency_two: currency_two).save
    redirect_to url_for(action: :manage_rate_comparisons)
  end

  def remove_rate_comparison
    RateComparison.delete(params[:rate_comparison_id])
    redirect_to url_for(action: :manage_rate_comparisons)
  end

private

  def rate_comparison_params
    params.require(:rate_comparison).permit(:currency_one, :currency_two)
  end

end