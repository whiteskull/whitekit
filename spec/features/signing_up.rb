require 'spec_helper'

feature "Signing up" do
  background do
    @user = create(:user)
  end

  scenario "Signing in with correct credentials" do
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user_email', :with => @user.email
      fill_in 'user_password', :with => @user.password
      click_button 'Sign in'
    end

    page.should have_no_content 'Invalid email or password'
  end

  scenario "Signing in with incorrect credentials" do
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user_email', :with => @user.email
      fill_in 'user_password', :with => 'qwkJahF2fqf'
      click_button 'Sign in'
    end

    page.should have_content 'Invalid email or password'
  end

end
