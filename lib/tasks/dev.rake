desc "Hydrate the database with some sample data to look at so that developing is easier"
require 'rake'
task({ :sample_data => :environment}) do

25.times do 
    client = Client.new
    client.email = Faker::Internet.email
    client.password = "password"
    client.firstname = Faker::Name.name
    client.lastname = Faker::Name.last_name
    client.save
end

last_round = ["Pre-Seed","Seed","A","B","C","D"]

25.times do 
    company = Company.new
    company.company_name = Faker::Company.name
    company.year_founded = Random.new.rand(2000..2020)
    company.industry = Faker::Company.industry
    company.vc_backed = Faker::Boolean.boolean
    company.last_round_type = last_round.sample
    company.valuation = Random.new.rand(1..100)
    company.deal_date = Random.new.rand(2000..2020)
    company.save
end

stocks = ["ISO","NSO","RSU"]

25.times do 
    comp_plan = CompensationPlan.new
    comp_plan.stock_type = stocks.sample
    comp_plan.strike_price = Random.new.rand(1..50)
    comp_plan.vesting_years = Random.new.rand(3..5)
    comp_plan.cliff = Random.new.rand(1..2)
    comp_plan.number_of_options = Random.new.rand(10..50)
    comp_plan.value_of_options = Random.new.rand(10000..1000000)
    comp_plan.salary = Random.new.rand(1..2)
    comp_plan.salary_period = Random.new.rand(1..2)
    comp_plan.bonus = Random.new.rand(1..2)
    comp_plan.save
end

end
