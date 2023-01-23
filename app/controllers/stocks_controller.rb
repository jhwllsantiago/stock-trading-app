class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show turbo_show]
  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
    @buys = Order.buy.pending.order(created_at: :desc)
    @sells = Order.sell.pending.order(created_at: :desc)
    @transactions = Transaction.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
  end

  def turbo_show
    @stocks = Stock.all
    @buys = Order.buy.pending.order(created_at: :desc)
    @sells = Order.sell.pending.order(created_at: :desc)
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
