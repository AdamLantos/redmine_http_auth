ActionController::Routing::Routes.draw do |map|
  map.httpauthlogin 'httpauth-login', :controller => 'welcome'
end
