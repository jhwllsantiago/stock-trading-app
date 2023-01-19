class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show ]

  # GET /stocks or /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @order = Order.new
    @asset = current_user.assets.find_by(stock_id: @stock.id)
  end

  private
    def set_stock
      @stock = Stock.find(params[:id])
    end
end
