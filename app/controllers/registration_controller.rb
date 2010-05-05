class RegistrationController < ApplicationController
  skip_before_filter :user_setup, :check_if_login_required
  include HttpAuthHelper
  helper :http_auth
  before_filter :autoregistration_enabled, :remote_user_set

  def autoregistration_form
    @user = User.new :language => Setting.default_language
    set_default_attributes @user
  end

  def register
    @user = User.new params[:user]
    set_readonly_attributes @user
    if @user.save
      redirect_to home_url
    else
      render 'autoregistration_form'
    end
  end

  def autoregistration_enabled
    unless Setting.
      plugin_http_auth['auto_registration'] == "true"

      flash[:error] = l :error_autoregistration_disabled
      redirect_to home_url
    end
  end

  def remote_user_set
    if remote_user.nil?
      flash[:error] = l :error_remote_user_unset
      redirect_to home_url
    end
  end
end
