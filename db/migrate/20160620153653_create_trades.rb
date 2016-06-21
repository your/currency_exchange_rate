class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string :direction
      t.integer :rate_comparison_id
      t.float :enter_rate
      t.float :exit_rate
      t.float :interest_rate
      t.float :interest_value
      t.datetime :closed_at

      t.timestamps null: false
    end
  end
end
