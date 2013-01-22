class ApplicationController < ActionController::Base

  before_filter :get_main_menu

  protect_from_forgery

  private

  def get_main_menu
    main_menu = Page.first
    @main_menu = main_menu.children.visible
  end
end
