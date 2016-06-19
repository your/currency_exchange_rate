require 'rails_helper'

RSpec.describe CurrencyController, type: :controller do

  describe 'POST #add_rate_comparison' do
    context 'with valid attributes' do
      it 'creates new rate comparison' do
        post :add_rate_comparison, rate_comparison: FactoryGirl.attributes_for(:rate_comparison)
        expect(RateComparison.count).to eq(1)
      end
    end
  end

  describe 'POST #remove_rate_comparison' do
    it 'removes a rate comparison' do
      post :remove_rate_comparison, rate_comparison_id: FactoryGirl.create(:rate_comparison)
      expect(RateComparison.count).to eq(0)
    end
  end


end