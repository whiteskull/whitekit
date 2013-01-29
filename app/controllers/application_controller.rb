class ApplicationController < ActionController::Base
  before_filter :get_main_menu
  before_filter :init_components

  protect_from_forgery

  private

  # Get main menu from pages
  def get_main_menu
    @main_menu = Page.arrange(order: :position)
  end

  def init_components
    BaseComponent.request = request
  end
end
