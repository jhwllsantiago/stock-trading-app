class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_stock
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    action = params[:order_action].to_i
    asset = current_user.assets.find_by(stock_id: @stock.id)
    price = order_params[:price]
    quantity = order_params[:quantity]
    @order = Order.new
    @order.action = action
    @order.status = 0
    @order.user = current_user
    @order.stock = @stock
    @order.price = @stock.price
    @order.quantity = quantity ? quantity.to_f : price.to_f/@stock.price.to_f
    orders = @stock.orders.where.not(user: current_user).where("price <= ? and quantity = ?", @order.price, @order.quantity)
    active_buy_order = orders.sell.first
    active_sell_order = orders.buy.first
    
    respond_to do |format|
      if  action == 0 and @order.price * @order.quantity > current_user.balance
        format.html { redirect_to stock_details_url(@stock), notice: "Insufficient balance." }
      elsif action == 1 and @order.quantity > asset&.quantity
        format.html { redirect_to stock_details_url(@stock), notice: "Insufficient #{@stock.ticker} assets." }
      elsif @order.save
        if action == 0
          current_user.balance -= @order.price * @order.quantity
          current_user.save
          if active_buy_order
            @order.update(status: 1)
            active_buy_order.update(status: 1)
            asset.quantity += @order.quantity
            asset.save
          end
        else
          asset.quantity -= @order.quantity
          asset.save
          if active_sell_order
            @order.update(status: 1)
            active_sell_order.update(status: 1)
            current_user.balance += @order.price * @order.quantity
            current_user.save
          end
        end
        if active_buy_order or active_sell_order
          format.html { redirect_to stock_details_url(@stock), notice: "Order has been fulfilled." }
        else
          format.html { redirect_to stock_details_url(@stock), notice: "Order was successfully created." } 
        end
      else
        format.html { render :create, notice: "Error while creating order.", status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_stock
      @stock = Stock.find(params[:stock_id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:quantity, :price)
    end
end
