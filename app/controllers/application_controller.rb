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
    @vesting_month.push(starting_month)
    @vested = the_plan.number_of_options * (0.25)
    @vested_stock.push(@vested)

    @months = (the_plan.vesting_years * 12) - starting_month
    current_month = starting_month + 1
    vest_per_month = ((the_plan.number_of_options * (0.75)) / @months)
    counter = 1

    while counter <= @months

        @vested = @vested + vest_per_month
        @vesting_month.push(current_month)
        @vested_stock.push(@vested.round)
        current_month = current_month + 1
        counter = counter + 1
    end
    @new_array = @vested_stock.map.with_index(starting_month){|i, starting_month| [starting_month, i]}

    @offer_value = cookies[:number_of_options].to_i ** cookies[:strike_price].to_i
    @taxes = @offer_value ** 0.16
    render({:template => "results/offer_results"})
  end
end
