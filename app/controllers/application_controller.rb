class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if resource.role == 'admin'
      admin_path
    else
      authenticated_root_path
    end
  end
end