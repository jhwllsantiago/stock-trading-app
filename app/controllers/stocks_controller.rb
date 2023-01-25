class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show turbo_show]
  before_action :authenticate_user!
  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
    # @buys = Order.buy.pending.includes(:user).order("users.role")
    # @sells = Order.sell.pending.includes(:user).order("users.role")
    @transactions = Transaction.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
  end

  def turbo_show
    @stocks = Stock.all
    @buys = @stock.orders.buy.pending.includes(:user).order("users.role")
    @sells = @stock.orders.sell.pending.includes(:user).order("users.role")
    @transactions = Transaction.all
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
    render partial: "index", status: :ok
  end

  private
    def set_stock
      @stock = Stock.find(params[:id])
    end
end
