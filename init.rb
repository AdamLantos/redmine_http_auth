require 'redmine'
require 'dispatcher'
require 'http_auth_patch'
 
Redmine::Plugin.register :http_auth do
  name 'HTTP Authentication plugin'
  author 'Adam Lantos'
  description 'A plugin for doing HTTP authentication'
  version '0.1'
end

Dispatcher.to_prepare do
  #include our code
  ApplicationController.send(:include, HTTPAuthPatch)
end
