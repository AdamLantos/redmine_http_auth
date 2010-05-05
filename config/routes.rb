ActionController::Routing::Routes.draw do |map|
  map.httpauthlogin 'httpauth-login', :controller => 'welcome'
  
  map.httpauthselfregister 'httpauth-selfregister/:action',
    :controller => 'registration', :action => 'autoregistration_form'
end
