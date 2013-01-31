module PagesHelper
  # Link to edit page
  def edit_page_for_admin
    if admin? && cookies['whitekit-edit'] == 'on'
      link_to t('whitekit.messages.edit_page'), rails_admin.edit_path(:page, @page.id), class: 'btn btn-info'
    end
  end
end
