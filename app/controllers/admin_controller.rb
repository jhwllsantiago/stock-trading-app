class AdminController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy user_row approve] 
    before_action :authenticate_user!
    before_action :check_admin

    def check_admin
        if !current_user&.admin?
            redirect_to dashboard_path
        end
    end

    def dashboard
        @users = User.where(role: 0)
    end

    def show
        @buy_transactions = @user.buyer_transactions
        @sell_transactions = @user.seller_transactions
        @assets = @user.assets
    end

    def transactions
        @transactions = Transaction.all
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

    private 
    
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
    end

end
