require 'spec_helper'

describe User do

  context "validate" do

    it "presence of email" do
      subject.email = nil
      subject.should validate_presence_of(:email)
    end

    it "presence of password" do
      subject.email = nil
      subject.should validate_presence_of(:email)
    end

    it "uniqueness of email" do
      create(:user)
      build(:user).should validate_uniqueness_of(:email)
    end

  end

  its(:admin) { should be_false }

  it "role admin can add only admin" do
    params = {email: 'newuser@mail.com', password: 'qwertyuiop', admin: true}
    expect { User.create(params) }.to raise_error
    expect { User.create(params, as: :admin) }.to_not raise_error
  end

  it "should have default admin user" do
    user = User.first
    user.admin.should be_true
  end

end
