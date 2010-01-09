module HTTPAuthPatch
  def self.included(base)
    base.send(:include, ClassMethods)
    base.class_eval do
      #avoid infinite recursion in development mode on subsequent requests
      alias_method :find_current_user,
        :find_current_user_without_httpauth if method_defined? 'find_current_user_without_httpauth'
      #chain our version of find_current_user implementation into redmine core
      alias_method_chain(:find_current_user, :httpauth)
    end
  end

  module ClassMethods
    def find_current_user_with_httpauth
      #first proceed with redmine's version of finding current user
      user = find_current_user_without_httpauth
      remote_username = request.env["REMOTE_USER"]
      if remote_username.nil?
        #do not touch user, if he didn't use http authentication to log in
        return user unless used_http_authentication?
        #log out previously authenticated user
        do_logout
        return nil
      end
      #log out current logged in user if the usernames do not match
      if user && user.login != remote_username
        do_logout
      end
      #find user by login name
      user = User.active.find_by_login remote_username
      #set http_authentication flag if a user was found
      mark_http_authentication unless user.nil?
      
      return user
    end

    def mark_http_authentication
      session[:http_authentication] = true
    end

    def do_logout
      session[:http_authentication] = nil
      logged_user = nil;
    end

    def used_http_authentication?
      session[:http_authentication] == true
    end
  end
end

