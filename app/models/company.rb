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
end
