require 'spec_helper'

describe User do

  its(:admin) { should be_false }

  it "role admin can add only admin" do
    expect { User.create({email: 'newuser@mail.com', password: 'qwertyuiop', admin: true}) }.to raise_error
    expect { User.create({email: 'newuser@mail.com', password: 'qwertyuiop', admin: true}, as: :admin) }.to_not raise_error
  end

  it "should have default admin user" do
    user = User.first
    user.admin.should be_true
  end

end
