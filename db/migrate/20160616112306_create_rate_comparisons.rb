class CreateRateComparisons < ActiveRecord::Migration

  def change
    create_table :rate_comparisons do |t|
      t.integer :currency_one_id
      t.integer :currency_two_id
    end
  end

end
