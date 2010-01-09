require 'redmine'
require 'http_auth_patch'
 
Redmine::Plugin.register :http_auth do
  name 'HTTP Authentication plugin'
  author 'Adam Lantos'
  description 'A plugin for doing HTTP authentication'
  version '0.1'
end
