RSpec.feature 'RateComparison', type: :feature do

  scenario 'Create a rate comparison' do

    begin
      currency_one = FactoryGirl.create(:currency)
      currency_two = FactoryGirl.create(:currency)
    end until currency_one.iso_code != currency_two.iso_code #If they're the same, the select below will fail

    rate_comparison = RateComparison.new(currency_one: currency_one, currency_two: currency_two)

    visit '/currency/manage_rate_comparisons'

    select currency_one.iso_code, :from => 'rate_comparison_currency_one'
    select currency_two.iso_code, :from => 'rate_comparison_currency_two'

    click_button 'add_rate_comparison'

    expect(page).to have_text(currency_one.iso_code)
    expect(page).to have_text(currency_two.iso_code)
    expect(page).to have_text(rate_comparison.exchange_rate)

  end

  scenario 'Remove a rate comparison' do

    currency_one = FactoryGirl.create(:currency)
    currency_two = FactoryGirl.create(:currency)
    rate_comparison = FactoryGirl.create(:rate_comparison, currency_one: currency_one, currency_two: currency_two)

    visit '/currency/manage_rate_comparisons'

    click_link 'remove_rate_comparison_' + rate_comparison.id.to_s

    visit '/currency/index'

    expect(page).not_to have_text(currency_one.iso_code)
    expect(page).not_to have_text(currency_two.iso_code)
    expect(page).not_to have_text(rate_comparison.exchange_rate)

  end

end