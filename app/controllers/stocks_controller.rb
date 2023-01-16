class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show ]

  # GET /stocks or /stocks.json
  def index
    # client = IEX::Api::Client.new(publishable_token: 'pk_79541eba9c3b47a89aad63f6efc2b5ab', endpoint: 'https://cloud.iexapis.com/v1')
    # @stocks = Stock.all.each do |stock|
    #   quote = client.quote(stock.ticker)
    #   stock.update(price: quote.latest_price)
    # end
    @stocks = Stock.all
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  private
    def set_stock
      @stock = Stock.find(params[:id])
    end
end
