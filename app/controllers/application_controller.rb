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
end
