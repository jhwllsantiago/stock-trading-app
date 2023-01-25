class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user 
    before_action :form_params
    before_action :check_status

    def dashboard
    end

    def deposit
        current_user.balance += form_params[:amount].to_f
        current_user.save
        render partial: "dashboard", locals: {balance: current_user.balance}, status: :ok
    end

    def withdraw
        if current_user.balance >= form_params[:amount].to_f
            current_user.balance -= form_params[:amount].to_f
            current_user.save
            render partial: "dashboard", locals: {balance: current_user.balance}, status: :ok
        end
    end

    def form_params
        params
    end

    def trade
    end

    def portfolio
        @buy_transactions = @user.buyer_transactions
        @sell_transactions = @user.seller_transactions
        @assets = @user.assets
    end

    private

    def set_user
        @user = current_user
    end

    def check_status
        if !@user.approved
            redirect_to stocks_path
        end
    end

end
