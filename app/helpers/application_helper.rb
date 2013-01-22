module ApplicationHelper
  def display_none_if(condition = true)
    'display: none;' if condition
  end

  def item_menu(item)
    content_for :li do
      'hello'
    end
  end
end
