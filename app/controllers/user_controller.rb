class UserController < ApplicationController

    def dashboard
        @user = current_user
    end

end
