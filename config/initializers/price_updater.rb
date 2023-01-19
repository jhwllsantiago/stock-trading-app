module StockTradingApp
  class Application < Rails::Application
    config.after_initialize do
      PriceUpdaterJob.perform_later
    end
  end
end