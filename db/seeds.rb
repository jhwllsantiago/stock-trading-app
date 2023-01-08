# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = User.create([
  {email: "admin@atlas.com", password: "password", password_confirmation: "password", first_name: "Atlas", last_name: "Admin", balance: 0.0, role: 1, approved: true},
  {email: "user@atlas.com", password: "password", password_confirmation: "password", first_name: "John", last_name: "Doe", balance: 150.00, role: 0, approved: false}
  ])
stocks = Stock.create([{ price: 15.12, company: "ABC Company" }, { price: 10.11, company: "DEF Company" }, { price: 1.01, company: "GHI Company" }])
Order.create([
  { action: 0, status: 0, quantity: 2, price: 15.06, user: users.first, stock: stocks.first },
  { action: 0, status: 1, quantity: 3, price: 0.7, user: users.first, stock: stocks.last } 
  ])