class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.integer :year_founded
      t.string :industry
      t.boolean :vc_backed
      t.string :last_round_type
      t.integer :valuation
      t.date :deal_date

      t.timestamps
    end
  end
end
