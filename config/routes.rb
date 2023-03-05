Rails.application.routes.draw do



  # Routes for the Compensation plan homeflow:
  post("/recalculate", {:controller => "application", :action => "recalculate"})
  post("/store_offer_cookies", {:controller => "compensation_plans", :action => "store_offer_cookies"})
  get("/", {:controller => "application", :action => "start"})
  get("/begin_service", {:controller => "application", :action => "begin_service"})
  get("/value_offer", {:controller => "application", :action => "value_offer"})
  get("/value_stock", {:controller => "application", :action => "value_stock"})
  
  
  # Routes for the Compensation plan calculation:
  get("/offer_calculation", {:controller => "application", :action => "offer_calculation" })

  # CREATE
  post("/insert_compensation_plan", { :controller => "compensation_plans", :action => "create" })
          
  # READ
  get("/compensation_plans", { :controller => "compensation_plans", :action => "index" })
  
  get("/compensation_plans/:path_id", { :controller => "compensation_plans", :action => "show" })
  
  # UPDATE
  
  post("/modify_compensation_plan/:path_id", { :controller => "compensation_plans", :action => "update" })
  
  # DELETE
  get("/delete_compensation_plan/:path_id", { :controller => "compensation_plans", :action => "destroy" })

  #------------------------------

  # Routes for the Client account:

  # SIGN UP FORM
  get("/client_sign_up", { :controller => "client_authentication", :action => "sign_up_form" })        
  # CREATE RECORD
  post("/insert_client", { :controller => "client_authentication", :action => "create"  })
  # SIGN OUT
  get("/destroy_cookies", {:controller => "client_authentication", :action => "destroy_cookies"})
      
  # EDIT PROFILE FORM        
  get("/edit_client_profile", { :controller => "client_authentication", :action => "edit_profile_form" })       
  # UPDATE RECORD
  post("/modify_client", { :controller => "client_authentication", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_client_account", { :controller => "client_authentication", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/client_sign_in", { :controller => "client_authentication", :action => "sign_in_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/client_verify_credentials", { :controller => "client_authentication", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/client_sign_out", { :controller => "client_authentication", :action => "destroy_cookies" })
             
  #------------------------------

  # Routes for the Company resource:

  # CREATE
  post("/insert_company", { :controller => "companies", :action => "create" })
          
  # READ
  get("/companies", { :controller => "companies", :action => "index" })
  
  get("/companies/:path_id", { :controller => "companies", :action => "show" })
  
  # UPDATE
  
  post("/modify_company/:path_id", { :controller => "companies", :action => "update" })
  
  # DELETE
  get("/delete_company/:path_id", { :controller => "companies", :action => "destroy" })

  #------------------------------

end
