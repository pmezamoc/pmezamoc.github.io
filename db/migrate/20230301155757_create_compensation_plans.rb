class CreateCompensationPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :compensation_plans do |t|
      t.string :stock_type
      t.integer :strike_price
      t.integer :vesting_years
      t.integer :cliff
      t.integer :number_of_options
      t.integer :value_of_options
      t.integer :salary
      t.string :salary_period
      t.integer :bonus
      t.integer :employee_id

      t.timestamps
    end
  end
end
