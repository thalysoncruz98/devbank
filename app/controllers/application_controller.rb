class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    protect_from_forgery

    #Redirect after login
    def after_sign_in_path_for(resource_or_scope)
        if resource_or_scope.is_a?(User)
          "/accounts"
        else
          super
        end
    end
end
