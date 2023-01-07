class UserMailer < ApplicationMailer
  before_action :set_user
  before_action :set_greeting
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    mail(to: @user.email, subject: "Welcome to Atlas")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.approved.subject
  #
  def approved
    mail(to: @user.email, subject: "Atlas Account Approval")
  end

  private

  def set_user
    @user = params[:user]
  end

  def set_greeting
    @greeting = "Hi, #{@user.first_name.capitalize}!"
  end
end
