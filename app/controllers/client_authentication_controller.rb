class ClientAuthenticationController < ApplicationController
  # Uncomment line 3 in this file and line 5 in ApplicationController if you want to force clients to sign in before any other actions.
  # skip_before_action(:force_client_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def sign_in_form
    render({ :template => "client_authentication/sign_in.html.erb" })
  end

  def create_cookie
    client = Client.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if client != nil
      are_they_legit = client.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/client_sign_in", { :alert => "Incorrect password." })
      else
        session[:client_id] = client.id
      
        redirect_to("/begin_service", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/client_sign_in", { :alert => "No client with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "client_authentication/sign_up.html.erb" })
  end

  def create
    @client = Client.new
    @client.email = params.fetch("query_email")
    @client.password = params.fetch("query_password")
    @client.password_confirmation = params.fetch("query_password_confirmation")
    @client.company_id = params.fetch("query_company_id")
    @client.firstname = params.fetch("query_firstname")
    @client.lastname = params.fetch("query_lastname")

    save_status = @client.save

    if save_status == true
      session[:client_id] = @client.id
   
      redirect_to("/begin_service", { :notice => "Client account created successfully."})
    else
      redirect_to("/client_sign_up", { :alert => @client.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "client_authentication/edit_profile.html.erb" })
  end

  def update
    @client = @current_client
    @client.email = params.fetch("query_email")
    @client.password = params.fetch("query_password")
    @client.password_confirmation = params.fetch("query_password_confirmation")
    @client.company_id = params.fetch("query_company_id")
    @client.firstname = params.fetch("query_firstname")
    @client.lastname = params.fetch("query_lastname")
    
    if @client.valid?
      @client.save

      redirect_to("/", { :notice => "Client account updated successfully."})
    else
      render({ :template => "client_authentication/edit_profile_with_errors.html.erb" , :alert => @client.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_client.destroy
    reset_session
    
    redirect_to("/", { :notice => "Client account cancelled" })
  end
 
end
