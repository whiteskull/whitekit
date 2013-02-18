class ApplicationController < ActionController::Base
  before_filter :get_main_menu
  before_filter :init_components

  protect_from_forgery

  # Get page by alias
  def get_page(name)
    @page = name.nil? ? Page.home.first : Page.get_by_alias(name).first
  end

  private

  # Get main menu from pages
  def get_main_menu
    return if params[:controller] == 'rails_admin/main'
    @main_menu = Rails.cache.fetch('main-menu', :expires_in => 24.hours) { Page.arrange(order: :position) }
  end
  
  def init_components
    BaseComponent.request = request
  end
end
