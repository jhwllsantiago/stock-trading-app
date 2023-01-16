# create one admin and three traders
User.create([
  {email: "admin@atlas.com", password: "password", password_confirmation: "password", first_name: "Atlas", last_name: "Admin", balance: 0.0, role: 1, approved: true},
  {email: "user@atlas.com", password: "password", password_confirmation: "password", first_name: "John", last_name: "Doe", balance: 150.00, role: 0, approved: true},
  {email: "user2@atlas.com", password: "password", password_confirmation: "password", first_name: "Jane", last_name: "Doe", balance: 123.00, role: 0, approved: true},
  {email: "user3@atlas.com", password: "password", password_confirmation: "password", first_name: "Juan", last_name: "Cruz", balance: 555.00, role: 0, approved: false}
  ])

# create stocks using iex api
tickers = %w(AAPL MSFT AMZN TSLA GOOGL GOOG BRK.B UNH JNJ XOM JPM META V PG NVDA HD CVX LLY MA ABBV PFE MRK PEP BAC KO)
client = IEX::Api::Client.new
tickers.each do |ticker|
  quote = client.quote(ticker)
  company = client.company(ticker)
  logo = client.logo(ticker)
  Stock.create(ticker: ticker, company: company.company_name, price: quote.latest_price, logo_url: logo.url)
end

# create one buy and one sell order for each stock
Stock.all.each do |stock|
  Order.create(action: 0, status: 0, quantity: 2, price: stock.price - 1.00, user_id: 2, stock_id: stock.id)
  Order.create(action: 1, status: 0, quantity: 5, price: stock.price + 1.00, user_id: 3, stock_id: stock.id)
end