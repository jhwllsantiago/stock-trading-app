class PagesController < ApplicationController
  def landing
    redirect_to stocks_path if current_user and current_user.trader?
    redirect_to admin_path if current_user and current_user.admin?
  end

  def error
  end
end
