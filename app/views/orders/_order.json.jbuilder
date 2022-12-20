json.extract! order, :id, :action, :status, :user_id, :stock_id, :quantity, :created_at, :updated_at
json.url order_url(order, format: :json)
