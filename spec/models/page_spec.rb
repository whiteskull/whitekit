require 'spec_helper'

describe Page do

  it "responds to" do
    should respond_to(:content, :description, :hidden, :keywords, :redirect_to, :title, :to_first,
                              :link, :title_seo, :title_page)
  end

  it "only admin can create a page" do
    expect { Page.create!({title: 'New page'}) }.to raise_error
    expect { Page.create!({title: 'New page'}, as: :admin) }.to_not raise_error
  end

  it "should have first page (main page) by default" do
    page = Page.first
    page.link.should eql '/'
  end

  it "is invalid without a title" do
    page = Page.new
    page.should_not be_valid
    page.title = 'Some title'
    page.should be_valid
  end

  it "set a link from the title" do
    page = Page.create({title: 'New page'}, as: :admin)
    page.link.should eql 'new-page'
  end

  it "should have correct link" do
    page = Page.create({title: 'New page'}, as: :admin)
    page.link = '   pAGe 109-!@#$%^&*()[].,/VEry_*+nEW    '
    page.save
    page.link.should eql 'page-109-very_new'
  end

end
