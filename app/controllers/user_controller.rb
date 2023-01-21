class UserController < ApplicationController
before_action :authenticate_user!
before_action :set_user 
before_action :form_params

    def dashboard
    end

    def deposit
        current_user.balance += form_params[:amount].to_f
        current_user.save
    end

    def withdraw
        current_user.balance -= form_params[:amount].to_f
        current_user.save
    end

    def form_params
        params
    end

    def set_user
        @user = current_user
    end

end
