# == Schema Information
#
# Table name: compensation_plans
#
#  id                :integer          not null, primary key
#  bonus             :integer
#  cliff             :integer
#  number_of_options :integer
#  salary            :integer
#  salary_period     :string
#  stock_type        :string
#  strike_price      :integer
#  value_of_options  :integer
#  vesting_years     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  employee_id       :integer
#
class CompensationPlan < ApplicationRecord

  belongs_to(:employee, { :required => true, :class_name => "Client", :foreign_key => "employee_id" })
  has_one(:company, { :through => :employee, :source => :company })

end
