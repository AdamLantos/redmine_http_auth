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
      #log out current user if remote_username is unset
      if remote_username.nil?
        logged_user = nil
        return nil
      end
      #log out current logged in user if the usernames do not match
      logged_user = nil if user && user.login != remote_username

      #find user by login name
      User.active.find_by_login remote_username
    end
  end
end

