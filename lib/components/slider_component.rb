class SliderComponent
  def initialize
    get_page
  end

  def get_page
    @page = Page.first
  end

  def result
    {page: @page, count: 3}
  end
end