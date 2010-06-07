module HttpAuthHelper
  unloadable
  
  def user_attributes
    ['login', 'mail', 'firstname', 'lastname']
  end

  def use_email?
    Setting.plugin_http_auth['lookup_mode'] == 'mail'
  end

  def set_default_attributes(user)
    user_attributes.each do |attr|
      user.send(attr + "=", (get_attribute_value attr))
    end
  end

  def set_readonly_attributes(user)
    user_attributes.each do |attr|
      user.send(attr + "=", (get_attribute_value attr)) if readonly_attribute? attr
    end
  end

  def remote_user
    request.env[Setting.plugin_http_auth['env_var']]
  end

  def readonly_attribute?(attribute_name)
    remote_user_attribute? attribute_name
    #todo else
  end

  private
  def remote_user_attribute?(attribute_name)
    (attribute_name == "login" && !use_email?) || (attribute_name == "mail" && use_email?)
  end

  def get_attribute_value(attribute_name)
    if remote_user_attribute? attribute_name
      remote_user
    else
      conf = Setting.plugin_http_auth['attribute_mapping']
      if conf.nil? || !conf.has_key?(attribute_name)
        nil
      else
        request.env[conf[attribute_name]]
      end
    end
  end

end
