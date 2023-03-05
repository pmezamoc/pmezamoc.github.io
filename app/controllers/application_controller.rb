class ApplicationController < ActionController::Base
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
    render({:template => "home/homepage"})
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
end
