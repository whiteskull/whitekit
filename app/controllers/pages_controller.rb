class PagesController < ApplicationController
  # View page
  # GET /some/page
  def index
    get_page(params[:alias])

    # Render not found page if page not found or hidden
    # TODO: do not found if among parent pages there are hidden
    if @page.blank? || @page.hidden?
      return render :page_not_found, status: 404
    end

    # If there is redirect_to then redirect page
    if @page.redirect_to.present?
      return redirect_to @page.redirect_to =~ /http:\/\// ? @page.redirect_to : page_url(@page.redirect_to)
    end

    # If there is to_first then redirect to first child page
    if @page.to_first?
      redirect_to page_url(@page.children.visible.sort_by_position.first.alias) if @page.has_children?
    end
  end

  # If page not found
  def page_not_found
  end
end
