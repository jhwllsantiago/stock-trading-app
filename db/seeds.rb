# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = User.create([
  {email: "admin@atlas.com", password: "password", password_confirmation: "password", first_name: "Atlas", last_name: "Admin", balance: 0.0, role: 1, approved: true},
  {email: "user@atlas.com", password: "password", password_confirmation: "password", first_name: "John", last_name: "Doe", balance: 150.00, role: 0, approved: false},
  {email: "user2@atlas.com", password: "password", password_confirmation: "password", first_name: "Jane", last_name: "Doe", balance: 123.00, role: 0, approved: false}
  ])

tickers = %w(AAPL MSFT AMZN TSLA GOOGL GOOG BRK.B UNH JNJ XOM JPM META V PG NVDA HD CVX LLY MA ABBV PFE MRK PEP BAC KO)
# stocks = Stock.create([{ price: 15.12, company: "ABC Company" }, { price: 10.11, company: "DEF Company" }, { price: 1.01, company: "GHI Company" }])
client = IEX::Api::Client.new(publishable_token: 'pk_79541eba9c3b47a89aad63f6efc2b5ab', endpoint: 'https://cloud.iexapis.com/v1')
tickers.length.times do |x|
  quote = client.quote(tickers[x])
  company = client.company(tickers[x])
  logo = client.logo(tickers[x])
  Stock.create(ticker: tickers[x], company: company.company_name, price: quote.latest_price, logo_url: logo.url)
end

# Order.create([
#   { action: 0, status: 0, quantity: 2, price: 15.06, user: users.first, stock: stocks.first },
#   { action: 0, status: 1, quantity: 3, price: 0.7, user: users.first, stock: stocks.last } 
#   ])