class AdminController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy user_row approve] 

    def dashboard
        @users = User.where(role: 0)
    end

    def show
    end
    
    def edit
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
              format.html { redirect_to admin_url, notice: "Account was successfully updated." }
              format.json { render :show, status: :ok, location: @user }
            else
              format.html { redirect_to edit_user_url(@user), status: :unprocessable_entity }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @user.destroy

        respond_to do |format|
            format.html { redirect_to admin_url, notice: "Account was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def approve
        # @user = User.find(params[:id])
        UserMailer.with(user: @user).approved.deliver_later
        @user.update(approved: true)
        render partial: "user_row", locals: {user: @user}, status: :ok
    end

    def user_row
        
    end

    private 
    
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
    end

end
