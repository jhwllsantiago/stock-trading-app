class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show turbo_show]
  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
    @buys = Order.buy.pending
    @sells = Order.sell.pending
    @transactions = Transaction.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
  end

  def turbo_show
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
    render partial: "stock_trade_form", locals: {stock: @stock}, status: :ok
    # transaction_show
  end

  # def transaction_show
  #   @transactions = Transaction.all
  #   render partial: "stock_transactions", locals: {transactions: @transactions}, status: :ok
  # end


  private
    def set_stock
      @stock = Stock.find(params[:id])
    end
end
