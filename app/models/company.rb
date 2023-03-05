# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  company_name    :string
#  deal_date       :date
#  industry        :string
#  last_round_type :string
#  valuation       :integer
#  vc_backed       :boolean
#  year_founded    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Company < ApplicationRecord
  has_many(:clients, { :class_name => "Client", :foreign_key => "company_id", :dependent => :destroy })

  has_many(:compensation_plans, { :through => :clients, :source => :compensation_plans })


end
