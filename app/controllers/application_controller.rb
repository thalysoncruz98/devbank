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

    #Redirect after logout
    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end

    #Lock account
    def lock_account
      current_user.lock_access!
      sign_out(current_user)
      redirect_to root_path, notice: "Sua conta foi bloqueada com sucesso."
    end
end
