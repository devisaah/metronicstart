class ApplicationController < ActionController::Base 
    protect_from_forgery prepend: true, with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_usuario!, :set_current_usuario
    after_action :flash_to_headers, :unset_current_usuario


    # Metodo usado pelo Cancan
    helper_method :current_user
        rescue_from CanCan::AccessDenied do |exception|
            respond_to do |format|
                format.json { head :forbidden, content_type: 'text/html' }
                format.html { redirect_to root_url, alert: exception.message }
                format.js   { head :forbidden, content_type: 'text/html' }
        end
    end

    rescue_from ActionController::InvalidAuthenticityToken do |exception|
        sign_out_user # Example method that will destroy the user cookies
    end
    
    def flash_to_headers
        return unless request.xhr?
        response.headers['X-Message'] = flash_message
        response.headers["X-Message-Type"] = flash_type.to_s
        flash.discard # don't want the flash to appear when you reload page
    end

    protected
        # Metodo usado pelo Cancan
        def current_user
            current_usuario
        end

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :username, :email, :ativo, :password, :password_confirmation])
            devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
            devise_parameter_sanitizer.permit(:account_update, keys: [:ativo, :nome, :username, :email, :password, :password_confirmation])
        end

    private
        def flash_message
            [:error, :warning, :notice].each do |type|
                return flash[type] unless flash[type].blank?
            end
        end

        def flash_type
            [:error, :warning, :notice].each do |type|
                return type unless flash[type].blank?
            end
        end

        def set_current_usuario
            Usuario.current = current_usuario
        end

        def unset_current_usuario
            Usuario.current = nil
        end
end