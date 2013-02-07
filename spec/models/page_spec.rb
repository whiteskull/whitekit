require 'spec_helper'

describe Page do

  it "is invalid without a title" do
    Page.new.should_not be_valid
  end

  it "only admin can create a page" do
    expect {Page.create!({title: 'New page'})}.to raise_error
    expect {Page.create!({title: 'New page'}, as: :admin)}.to_not raise_error
  end

  it "set a link from the title" do
    page = Page.create({title: 'New page'}, as: :admin)
    page.link.should == 'new-page'
  end

end
