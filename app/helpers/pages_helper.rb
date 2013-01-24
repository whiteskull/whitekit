module PagesHelper

  # Redirect to edit page
  def edit_page_for_admin
    if admin?
      link_to 'Edit', rails_admin.edit_path('page', @page.id), class: 'btn'
    end
  end
end
