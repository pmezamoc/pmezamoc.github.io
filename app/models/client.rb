# == Schema Information
#
# Table name: clients
#
#  id              :integer          not null, primary key
#  email           :string
#  firstname       :string
#  lastname        :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  company_id      :integer
#
class Client < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
end
