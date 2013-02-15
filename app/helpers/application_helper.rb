# coding: utf-8
module ApplicationHelper
  # Hide display block if condition is true
  def display_none_if(condition = true)
    'display: none;' if condition
  end

  # Main menu
  def nested_pages(pages, root_page = '/')
    unless root_page == '/'
      root_page = "separator-#{root_page}" unless root_page =~ /^separator-/
    end
    pages.map do |page, sub_pages|
      unless page.hidden
        if page.link == root_page
          content_tag(:ul, nested_pages(sub_pages), class: 'root-pages')
        elsif page.ancestry && page.link !~ /^separator-/
          ul_sub = page.has_children? ? content_tag(:ul, nested_pages(sub_pages), class: "nested-pages level-#{page.depth}") : ''
          render(partial: 'pages/item_menu', locals: {item: page, ul_sub: ul_sub})
        end
      end
    end.join.html_safe
  end

  # Breadcrumbs
  def breadcrumbs
    if @page.present?
      breadcrumbs_html = ''
      @page.ancestors.each do |page|
        link = page.alias.present? ? page_path(page.alias) : root_path
        breadcrumbs_html << link_to(page.title, link) + ' · '
      end
      breadcrumbs_html << @page.title
      raw breadcrumbs_html
    end
  end

  # Check if user admin?
  def admin?
    user_signed_in? && current_user.admin?
  end

  def separate_links(separate)
    '·' unless separate == false
  end
end
