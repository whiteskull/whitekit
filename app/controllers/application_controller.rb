class ApplicationController < ActionController::Base
  before_filter :get_main_menu

  protect_from_forgery

  private

  # Get main menu from pages
  def get_main_menu
    @main_menu = Page.arrange(order: :position)
  end
end
