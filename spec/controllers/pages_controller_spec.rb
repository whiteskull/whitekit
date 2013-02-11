require 'spec_helper'

describe PagesController do
  render_views

  context "admin" do
    login_admin

    it "should have the admin tools" do
      get 'index'
      response.body.should have_selector('#whitekit-tools')
    end

    it "should have the tree site only when there is cookie" do
      get 'index'
      response.body.should have_selector('#whitekit-site', visible: false)

      cookies['whitekit-edit'] = 'on'
      get 'index'
      response.body.should have_selector('#whitekit-site', visible: true)
    end
  end

  context "user" do
    login_user

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    it "should get index" do
      get 'index'
      response.should be_success
    end

    it "should not have the admin tools" do
      get 'index'
      response.body.should_not have_selector('#whitekit-tools')
    end

    it "should not have the tree site" do
      get 'index'
      response.body.should_not have_selector('#whitekit-site')
    end
  end

  it "should have the right title" do
    get 'index'
    response.body.should have_selector('title', :text => 'Main page')

    Page.first.update_attribute(:title, 'Other title')
    get 'index'
    response.body.should have_selector('title', :text => 'Other title')
  end

end
