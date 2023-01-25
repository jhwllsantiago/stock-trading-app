class PriceUpdaterJob < ApplicationJob
  queue_as :default
  after_perform do |job|
    self.class.set(:wait => 1.hour).perform_later
  end

  def perform(*args)
    client = IEX::Api::Client.new
    Stock.all.each do |stock|
      if Time.now - stock.updated_at > 1.hour
        quote = client.quote(stock.ticker)
        stock.update(price: quote.latest_price)
        stock.orders.by_admin.each do |order|
          order.update(price: quote.latest_price, quantity: 10000.0, status: 0)
        end
      end
    end
  end
end
