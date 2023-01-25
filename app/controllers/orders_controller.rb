class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :set_stock, except: %i[ index cancel]
  before_action :set_order_details, only: %i[ buy sell ]
  before_action :set_orders, only: %i[ index cancel ]

  # GET /orders or /orders.json
  def index
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
  end

  # POST /orders/buy/:stock_id
  def buy
    @order.action = 0
    orders = active_orders_for(@order).sell

    respond_to do |format|
      if @order.price * @order.quantity > current_user.balance
        format.html { redirect_to stock_turbo_show_url(@stock), notice: "Insufficient balance." }
      elsif @order.save
        current_user.balance -= @order.price * @order.quantity
        current_user.save
        if !orders.empty?
          required_quantity = @order.quantity
          accumulated_quantity = 0.0
          orders.each do |order|
            if accumulated_quantity >= @order.quantity
              break
            elsif order.quantity >= required_quantity
              Transaction.create(buyer: current_user, seller: order.user, stock: @stock, price: @order.price, quantity: required_quantity)
              order.user.update(balance: order.user.balance + required_quantity * order.price)
              order.quantity -= required_quantity
              order.status = 1 if order.quantity == 0.0
              order.save
              accumulated_quantity += required_quantity
              required_quantity = 0.0
            elsif order.quantity < required_quantity
              Transaction.create(buyer: current_user, seller: order.user, stock: @stock, price: @order.price, quantity: order.quantity)
              required_quantity -= order.quantity
              accumulated_quantity += order.quantity
              order.user.update(balance: order.user.balance + order.quantity * order.price)
              order.update(quantity: 0.0, status: 1)
            end
          end
          @order.status = 1 if accumulated_quantity >= @order.quantity
          @order.quantity -= accumulated_quantity
          @asset.quantity += accumulated_quantity
          @order.save
          @asset.save
          format.html { redirect_to stock_turbo_show_url(@stock), notice: "Order has been #{"partially" if required_quantity > 0.0} fulfilled." }
        else
          format.html { redirect_to stock_turbo_show_url(@stock), notice: "Order has been posted." } 
        end
      else
        format.html { render :create, notice: "Cannot process order.", status: :unprocessable_entity }
      end
    end
  end

  # POST /orders/sell/:stock_id
  def sell
    @order.action = 1
    orders = active_orders_for(@order).buy

    respond_to do |format|
      if @order.quantity > @asset.quantity
        format.html { redirect_to stock_turbo_show_url(@stock), notice: "Insufficient assets." }
      elsif @order.save
        @asset.quantity -= @order.quantity
        @asset.save
        if !orders.empty?
          required_quantity = @order.quantity
          accumulated_quantity = 0.0
          orders.each do |order|
            asset = order.user.assets.find_by(stock_id: @stock.id)
            if accumulated_quantity >= @order.quantity
              break
            elsif order.quantity >= required_quantity
              Transaction.create(buyer: order.user, seller: current_user, stock: @stock, price: @order.price, quantity: required_quantity)
              asset.update(quantity: asset.quantity + required_quantity)
              order.quantity -= required_quantity
              order.status = 1 if order.quantity == 0.0
              order.save
              accumulated_quantity += required_quantity
              required_quantity = 0.0
            elsif order.quantity < required_quantity
              Transaction.create(buyer: order.user, seller: current_user, stock: @stock, price: @order.price, quantity: order.quantity)
              required_quantity -= order.quantity
              accumulated_quantity += order.quantity
              asset.update(quantity: asset.quantity + order.quantity)
              order.update(quantity: 0.0, status: 1)
            end
          end
          @order.status = 1 if accumulated_quantity >= @order.quantity
          @order.quantity -= accumulated_quantity
          current_user.balance += @order.price * accumulated_quantity
          @order.save
          current_user.save
          format.html { redirect_to stock_turbo_show_url(@stock), notice: "Order has been #{"partially" if required_quantity > 0.0} fulfilled." }
        else
          format.html { redirect_to stock_turbo_show_url(@stock), notice: "Order has been posted." } 
        end
      else
        format.html { render :create, notice: "Cannot process order.", status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH /orders/cancel/:id
  def cancel
    @order.update(status: 2)
    current_user.balance += @order.price
    current_user.save
    render partial: "order_table", locals: {orders: @orders}, status: :ok
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
    def set_order
      @order = Order.find(params[:id])
    end

    def set_orders
      @orders = current_user.orders.order(status: :asc)
    end

    def set_stock
      @stock = Stock.find(params[:stock_id])
    end

    def order_params
      params.require(:order).permit(:quantity, :price)
    end

    def set_order_details
      @asset = current_user.assets.find_by(stock_id: @stock.id)
      @asset = Asset.create(user: current_user, stock: @stock, quantity: 0.0) if !@asset
      @price = order_params[:price]
      @quantity = order_params[:quantity]
      @order = Order.new(status: 0, user: current_user, stock: @stock, price: @stock.price)
      @order.quantity = @quantity ? @quantity.to_f : @price.to_f/@stock.price.to_f
    end
    
    def active_orders_for order
      orders = @stock.orders.where.not(user: current_user).where(price: order.price).pending.includes(:user).order("users.role")
    end
end
