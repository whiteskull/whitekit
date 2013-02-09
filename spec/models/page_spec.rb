require 'spec_helper'

describe Page do

  context "validate" do

    it "presence of title" do
      subject.title = nil
      subject.should validate_presence_of(:title)
    end

    it "presence of link" do
      subject.link = nil
      subject.should validate_presence_of(:link)
    end

  end

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
    page.link.should eq '/'
  end

  it "set a link from the title" do
    create(:page).link.should eq 'new-page'
  end

  it "should have correct link" do
    create(:page, link: '   pAGe 109-!@#$%^&*()[].,/VEry_*+nEW    ').link.should eq 'page-109-very_new'
  end

end
