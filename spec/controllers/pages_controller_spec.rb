require 'spec_helper'

describe PagesController do
  render_views

  it "should have the right title" do
    get 'index'

    response.should have_selector('title', :content => 'Main page')
  end

end
