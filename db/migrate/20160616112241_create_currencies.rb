class CreateCurrencies < ActiveRecord::Migration

  def change
    create_table :currencies do |t|
      t.string :iso_code
      t.float :rate
      t.timestamps
    end
  end

end
