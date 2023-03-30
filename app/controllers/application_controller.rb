class ApplicationController < ActionController::Base
  require 'enumerator'
  before_action(:load_current_client)
  
  # Uncomment line 5 in this file and line 3 in ClientAuthenticationController if you want to force clients to sign in before any other actions.
  # before_action(:force_client_sign_in)
  
  def load_current_client
    the_id = session[:client_id]
    
    @current_client = Client.where({ :id => the_id }).first
  end
  
  def force_client_sign_in
    if @current_client == nil
      redirect_to("/client_sign_in", { :notice => "You have to sign in first." })
    end
  end

  def start
    render({:template => "home/index"})
  end 

  def begin_service

    render({:template => "home/begin_service"})
  end

  def value_offer
    render({:template => "home/value_offer"})
  end

  def value_stock
    render({:template => "home/value_stock"})
  end

  def offer_calculation
    the_plan = CompensationPlan.new

    the_plan.employee_id = session[:client_id] 
    the_plan.stock_type  = cookies.fetch(:stock_type) 
    the_plan.strike_price  = cookies.fetch(:strike_price) 
    the_plan.vesting_years = cookies.fetch(:vesting_years) 
    the_plan.cliff = cookies.fetch(:cliff) 
    the_plan.number_of_options = cookies.fetch(:number_of_options) 

    the_plan.save

    #vesting calendar
    @vesting_month = Array.new
    @vested_stock = Array.new
    starting_month = the_plan.cliff * 12
    counter = 1

    @vesting_month.push(starting_month)
    @vested = the_plan.number_of_options * (0.25)

    while counter <= starting_month
      if counter < starting_month
        @vested_stock.push(0)
      else 
        @vested_stock.push(@vested)
      end
      counter = counter + 1 
    end

    @months = (the_plan.vesting_years * 12) - starting_month
    current_month = starting_month + 1
    vest_per_month = ((the_plan.number_of_options * (0.75)) / @months)
    counter = 1

    while counter <= @months
        @vested = @vested + vest_per_month
        @vested_stock.push(@vested.round) 
        counter = counter + 1 
    end

    @vesting_calendar = @vested_stock.map.with_index(1){|i, ind| [ind, i]}

    #2Y scenario 
    years = Array.new
    years = ["2x","5x","10x"]
    @potential_upside = Array.new
    @taxes = Array.new
    @cost_to_exercise = Array.new
    
    @stocks_vested = @vesting_calendar.select{|(x, y)| x==the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price) + ((@stocks_vested * -the_plan.strike_price) * 0.20))

    @stocks_vested = @vesting_calendar.select{|(x, y)| x==the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price * 5) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price * 5) + ((@stocks_vested * -the_plan.strike_price * 5) * 0.20))

    @stocks_vested = @vesting_calendar.select{|(x, y)| x == the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price * 10) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price * 10) + ((@stocks_vested * -the_plan.strike_price * 10) * 0.20))

    @cost_to_exercise = @cost_to_exercise.zip(years).map(&:reverse)
    @potential_upside = @potential_upside.zip(years).map(&:reverse)
    @taxes = @taxes.zip(years).map(&:reverse)
    render({:template => "results/offer_results"})
  end

  def recalculate
    the_plan = CompensationPlan.new

    the_plan.employee_id = session[:client_id] 
    the_plan.stock_type  = params.fetch("query_stock_type") 
    the_plan.strike_price  = params.fetch("query_strike_price") 
    the_plan.vesting_years = params.fetch("query_vesting_years") 
    the_plan.cliff = params.fetch("query_cliff") 
    the_plan.number_of_options = params.fetch("query_number_of_options") 

    the_plan.save

    #vesting calendar
    @vesting_month = Array.new
    @vested_stock = Array.new
    starting_month = the_plan.cliff * 12
    counter = 1

    @vesting_month.push(starting_month)
    @vested = the_plan.number_of_options * (0.25)

    while counter <= starting_month
      if counter < starting_month
        @vested_stock.push(0)
      else 
        @vested_stock.push(@vested)
      end
      counter = counter + 1 
    end

    @months = (the_plan.vesting_years * 12) - starting_month
    current_month = starting_month + 1
    vest_per_month = ((the_plan.number_of_options * (0.75)) / @months)
    counter = 1

    while counter <= @months
        @vested = @vested + vest_per_month
        @vested_stock.push(@vested.round) 
        counter = counter + 1 
    end

    @vesting_calendar = @vested_stock.map.with_index(1){|i, ind| [ind, i]}

    #2Y scenario 
    years = Array.new
    years = ["2x","5x","10x"]
    @potential_upside = Array.new
    @taxes = Array.new
    @cost_to_exercise = Array.new
    
    @stocks_vested = @vesting_calendar.select{|(x, y)|x== the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price) + ((@stocks_vested * -the_plan.strike_price) * 0.20))

    @stocks_vested = @vesting_calendar.select{|(x, y)|x== the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price * 5) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price * 5) + ((@stocks_vested * -the_plan.strike_price * 5) * 0.20))

    @stocks_vested = @vesting_calendar.select{|(x, y)| x == the_plan.vesting_years*12}.map{|(x, y)| y}.join.to_i
    @cost_to_exercise.push(@stocks_vested * -the_plan.strike_price)
    @taxes.push((@stocks_vested * -the_plan.strike_price * 10) * 0.20)
    @potential_upside.push(-(@stocks_vested * -the_plan.strike_price * 10) + ((@stocks_vested * -the_plan.strike_price * 10) * 0.20))

    @cost_to_exercise = @cost_to_exercise.zip(years).map(&:reverse)
    @potential_upside = @potential_upside.zip(years).map(&:reverse)
    @taxes = @taxes.zip(years).map(&:reverse)
    render({:template => "results/offer_results"})
  end

  def taxes(taxable_income)
  tax_results = Array.new
  taxable_income.each do |yearly_income|
  if (yearly_income.to_f > 8952)
    first_bracket = 8952*0.0192
  else
    first_bracket = yearly_income.to_f*0.0192
  end
  if (first_bracket < 0)
    first_bracket = 0
  end
  if (yearly_income.to_f > 75985)
    second_bracket = (75985-8952)*0.064
  else
    second_bracket = (yearly_income.to_f-8952)*0.064
  end
  if (second_bracket < 0)
    second_bracket = 0
  end
  if (yearly_income.to_f > 133536)
    third_bracket = (133536-75985)*0.1088
  else
    third_bracket = (yearly_income.to_f-75985)*0.1088
  end
  if (third_bracket < 0)
    third_bracket = 0
  end
  if (yearly_income.to_f > 155230)
    forth_bracket = (155230-133536)*0.16
  else
    forth_bracket = (yearly_income.to_f-133536)*0.16
  end
  if (forth_bracket < 0)
    forth_bracket = 0
  end
  if (yearly_income.to_f > 185853)
    fifth_bracket = (185853-155230)*0.1792
  else
    fifth_bracket = (yearly_income.to_f-155230)*0.1792
  end
  if (fifth_bracket < 0)
    fifth_bracket = 0
  end
  if (yearly_income.to_f > 374838)
    sixth_bracket = (374838-185853)*0.2136
  else
    sixth_bracket = (yearly_income.to_f-185853)*0.2136
  end
  if (sixth_bracket < 0)
    sixth_bracket = 0
  end
  if (yearly_income.to_f > 590796)
    seventh_bracket = (590796-374838)*0.2352
  else
    seventh_bracket = (yearly_income.to_f-374838)*0.2352
  end
  if (seventh_bracket < 0)
    seventh_bracket = 0
  end
  if (yearly_income.to_f > 1127927)
    eighth_bracket = (1127927-590796)*0.30
  else
    eighth_bracket = (yearly_income.to_f-590796)*0.30
  end
  if (eighth_bracket < 0)
    eighth_bracket = 0
  end
  if (yearly_income.to_f > 1503902)
    nineth_bracket = (1503902-1127927)*0.32
  else
    nineth_bracket = (yearly_income.to_f-1127927)*0.32
  end
  if (nineth_bracket < 0)
    nineth_bracket = 0
  end
  if (yearly_income.to_f > 4511707)
    tenth_bracket = (4511707-1503902)*0.34
  else
    tenth_bracket = (yearly_income.to_f-1503902)*0.34
  end
  if (tenth_bracket < 0)
    tenth_bracket = 0
  end
  if (yearly_income.to_f > 1000000000)
    eleventh_bracket = (1000000000-4511707)*0.35
  else
    eleventh_bracket = (yearly_income.to_f-4511707)*0.35
  end
  if (eleventh_bracket < 0)
    eleventh_bracket = 0
  end
  tax = -(first_bracket + second_bracket + third_bracket + forth_bracket + fifth_bracket + sixth_bracket + seventh_bracket + eighth_bracket + nineth_bracket + tenth_bracket + eleventh_bracket)
  tax_results.push(tax)
  end
  return tax_results
end


  def equity_calculation
    the_plan = CompensationPlan.new

    the_plan.employee_id = session[:client_id] 
    the_plan.stock_type  = cookies.fetch(:stock_type) 
    the_plan.strike_price  = cookies.fetch(:price_at_grant).to_f
    the_plan.vesting_years = cookies.fetch(:vesting_years).to_f
    the_plan.cliff = cookies.fetch(:cliff).to_f 
    the_plan.number_of_options = cookies.fetch(:number_of_stock).to_f
    the_plan.salary = cookies.fetch(:yearly_salary)
    the_plan.bonus = cookies.fetch(:yearly_bonus)

    @expected_appreciation = cookies.fetch(:expected_appreciation).to_f - 1
    @years_to_liquidity = cookies.fetch(:years_to_liquidity).to_f

    the_plan.save

    #vesting calendar
    @vesting_month = Array.new
    @vested_stock = Array.new
    starting_month = the_plan.cliff * 12
    counter = 1

    @vesting_month.push(starting_month)
    @vested = the_plan.number_of_options * (0.25)
    @appreciation = Array.new
    monthly_appreciation_t = (the_plan.strike_price * @expected_appreciation)/(@years_to_liquidity * 12)
    monthly_appreciation = (the_plan.strike_price * @expected_appreciation)/(@years_to_liquidity * 12)

    #Appreciation array
    while counter <= @years_to_liquidity*12
      @appreciation.push(monthly_appreciation_t.round(2))
      monthly_appreciation_t = monthly_appreciation_t + monthly_appreciation
      counter = counter + 1
    end

    counter = 1

    #Vesting Calendar
    while counter <= starting_month
      if counter < starting_month
        @vested_stock.push(0)
      else 
        @vested_stock.push(@vested)
      end
      counter = counter + 1 
    end

    @months = (the_plan.vesting_years * 12) - starting_month
    current_month = starting_month + 1
    vest_per_month = ((the_plan.number_of_options * (0.75)) / @months)
    counter = 1
    vest = @vested.dup

    while counter <= @months
        vest = vest + vest_per_month
        @vested_stock.push(vest.round) 
        counter = counter + 1 
    end

    #Equity Income 
    extra_months = (@years_to_liquidity*12) - (the_plan.vesting_years * 12)
    @tax_stock = Array.new
    counter = 1
    while counter <= starting_month
      if counter < starting_month
        @tax_stock.push(0)
      else 
        @tax_stock.push(@vested)
      end
      counter = counter + 1 
    end

    counter = 1
    while counter <= @months
        vest = vest_per_month
        @tax_stock.push(vest_per_month) 
        counter = counter + 1 
    end

    counter = 1
    while counter <= extra_months
      @tax_stock.push(0)
      counter = counter + 1
    end

    market_value = Array.new
    market_value = @appreciation.map{|num| num + the_plan.strike_price}
    @taxable_income = market_value.zip(@tax_stock).map{|x, y| x * y}
    @yearly_income = Array.new
    @yearly_income = @taxable_income.each_slice(12).to_a
    @income = Array.new

    counter = 0 
    while counter < @yearly_income.length
      sum = @yearly_income.at(counter).inject(:+)
      @income.push(sum)
      counter = counter+1
    end

    #Market Value of Stock
    stock_value = Array.new
    stock_value = @vested_stock.dup

    counter = 1
    while counter <= extra_months
      stock_value.push(@vested_stock.last)
      counter = counter + 1
    end

    market_value = market_value.zip(stock_value).map{|x, y| x * y}

    #Cash Compensation
    cash_comp = Array.new
    counter = 1

    while counter <= @years_to_liquidity
      comp = (the_plan.salary + the_plan.bonus)*(1.05**(counter-1))
      cash_comp.push(comp)
      counter = counter + 1
    end 
    #Capital Gains Tax
    counter = 1
    cap_gains = Array.new 
    while counter <= @years_to_liquidity
      cap_gains.push(0)
      counter = counter + 1
    end 
    cap_gains.pop
    cap_gains.push(market_value.last)

    capital_gains_tax = cap_gains.map{|x| x * -0.10}

    #Cash Flows
    cash_flows = Array.new
    @cash_flows_i = Array.new
    cash_flows = cash_comp.zip(@income).map{|x,y| x+y}
    @cash_flows_i = cash_comp.zip(cap_gains).map{|x,y| x+y}.map.with_index(1){|i,ind| [ind,i]}

    #Individual values, I need to get stock income and  cash income
    tax_results = taxes(cash_flows)
    puts cap_gains #money from selling stock
    puts cash_comp #cash comp
    puts tax_results #income tax 
    puts capital_gains_tax # capital gains tax
    puts cash_flows #income tax + equity gains

    @total_cash =  cash_comp.inject(:+)
    @total_stock = cap_gains.inject(:+)
    @income_tax = tax_results.inject(:+)
    @capital_tax = capital_gains_tax.inject(:+)
    @net_comp = @total_cash + @total_stock

    puts @total_cash
    puts @total_stock

    @vesting_calendar = @vested_stock.map.with_index(1){|i, ind| [ind, i]}
    render({:template => "results/equity_results"})
  end

end
