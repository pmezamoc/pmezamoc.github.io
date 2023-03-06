class CompensationPlansController < ApplicationController
  def index
    matching_compensation_plans = CompensationPlan.all

    @list_of_compensation_plans = matching_compensation_plans.order({ :created_at => :desc })

    render({ :template => "compensation_plans/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_compensation_plans = CompensationPlan.where({ :id => the_id })

    @the_compensation_plan = matching_compensation_plans.at(0)

    render({ :template => "compensation_plans/show.html.erb" })
  end

  def create
    the_compensation_plan = CompensationPlan.new
    the_compensation_plan.stock_type = params.fetch("query_stock_type")
    the_compensation_plan.strike_price = params.fetch("query_strike_price")
    the_compensation_plan.vesting_years = params.fetch("query_vesting_years")
    the_compensation_plan.cliff = params.fetch("query_cliff")
    the_compensation_plan.number_of_options = params.fetch("query_number_of_options")
    the_compensation_plan.value_of_options = params.fetch("query_value_of_options")
    the_compensation_plan.salary = params.fetch("query_salary")
    the_compensation_plan.salary_period = params.fetch("query_salary_period")
    the_compensation_plan.bonus = params.fetch("query_bonus")
    the_compensation_plan.employee_id = params.fetch("query_employee_id")

    if the_compensation_plan.valid?
      the_compensation_plan.save
      redirect_to("/compensation_plans", { :notice => "Compensation plan created successfully." })
    else
      redirect_to("/compensation_plans", { :alert => the_compensation_plan.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_compensation_plan = CompensationPlan.where({ :id => the_id }).at(0)

    the_compensation_plan.stock_type = params.fetch("query_stock_type")
    the_compensation_plan.strike_price = params.fetch("query_strike_price")
    the_compensation_plan.vesting_years = params.fetch("query_vesting_years")
    the_compensation_plan.cliff = params.fetch("query_cliff")
    the_compensation_plan.number_of_options = params.fetch("query_number_of_options")
    the_compensation_plan.value_of_options = params.fetch("query_value_of_options")
    the_compensation_plan.salary = params.fetch("query_salary")
    the_compensation_plan.salary_period = params.fetch("query_salary_period")
    the_compensation_plan.bonus = params.fetch("query_bonus")
    the_compensation_plan.employee_id = params.fetch("query_employee_id")

    if the_compensation_plan.valid?
      the_compensation_plan.save
      redirect_to("/compensation_plans/#{the_compensation_plan.id}", { :notice => "Compensation plan updated successfully."} )
    else
      redirect_to("/compensation_plans/#{the_compensation_plan.id}", { :alert => the_compensation_plan.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_compensation_plan = CompensationPlan.where({ :id => the_id }).at(0)

    the_compensation_plan.destroy

    redirect_to("/compensation_plans", { :notice => "Compensation plan deleted successfully."} )
  end


  def store_offer_cookies
    cookies.store(:company, params.fetch("query_company"))  
    cookies.store(:stock_type, params.fetch("query_stock_type"))
    cookies.store(:strike_price, params.fetch("query_strike_price"))
    cookies.store(:vesting_years, params.fetch("query_vesting_years"))
    cookies.store(:cliff, params.fetch("query_cliff"))
    cookies.store(:number_of_options, params.fetch("query_number_of_options"))
  if session[:client_id] == nil 
    redirect_to("/client_sign_up")
  else 
    redirect_to("/offer_calculation")
  end
end

def store_equity_cookies
  cookies.store(:company, params.fetch("query_company"))  
  cookies.store(:stock_type, params.fetch("query_stock_type"))
  cookies.store(:price_at_grant, params.fetch("query_price_at_grant"))
  cookies.store(:vesting_years, params.fetch("query_vesting_years"))
  cookies.store(:cliff, params.fetch("query_cliff"))
  cookies.store(:number_of_stock, params.fetch("query_number_of_stocks"))
  cookies.store(:expected_appreciation, params.fetch("query_expected_appreciation"))
  cookies.store(:years_to_liquidity, params.fetch("query_years_to_liquidity"))
if session[:client_id] == nil 
  redirect_to("/client_sign_up")
else 
  redirect_to("/equity_calculation")
end
end
end
