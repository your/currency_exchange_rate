class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.float :amount

      t.timestamps null: false
    end
  end
end
