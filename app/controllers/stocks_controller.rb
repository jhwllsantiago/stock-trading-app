class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show ]

  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
    @buys = Order.buy.pending
    @sells = Order.sell.pending
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  private
    def set_stock
      @stock = Stock.find(params[:id])
    end
end
