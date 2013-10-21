class CustomUsersController < Devise::RegistrationsController
  def new
    super
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      @text_message = TextMessage.find_by_id(session[:text_message_id])
      @text_message.user_id = resource.id
      @text_message.save

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end
  