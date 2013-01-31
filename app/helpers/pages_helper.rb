module PagesHelper
  # Link to edit page
  def edit_page_for_admin
    if admin? && cookies['whitecms-edit'] == 'on'
      link_to t('whitecms.messages.edit_page'), rails_admin.edit_path(:page, @page.id), class: 'btn btn-info'
    end
  end
end
