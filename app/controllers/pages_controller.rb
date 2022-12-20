class PagesController < ApplicationController
  def landing
    redirect_to stocks_path if current_user and current_user.trader?
  end

  def error
  end
end
