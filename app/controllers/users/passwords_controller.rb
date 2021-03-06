class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.find_or_initialize_with_errors(Devise.reset_password_keys, resource_params, :not_found)
    if Rails.env.production?
      if self.resource.persisted? && verify_rucaptcha?(resource)
        self.resource.send_reset_password_instructions
      end

      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    else
      super
    end
  end

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
