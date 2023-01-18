class PriceUpdaterJob < ApplicationJob
  queue_as :default
  after_perform do |job|
    self.class.set(:wait => 1.hour).perform_later
  end

  def perform(*args)
    client = IEX::Api::Client.new
    Stock.all.each do |stock|
      quote = client.quote(stock.ticker)
      stock.update(price: quote.latest_price)
      Order.where(user_id: User.find_by(role: 1)).sell.pending.each do |order|
        order.update(price: quote.latest_price)
      end
    end
  end
end
