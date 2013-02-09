require 'spec_helper'

describe BlockPosition do

  it_behaves_like "blocks", BlockPosition.new

  it "responds to" do
    should respond_to(:alias, :hidden, :name)
  end

end
