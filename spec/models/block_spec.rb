require 'spec_helper'

describe Block do

  it_behaves_like "blocks", Block.new

  it "validate presence of visibility_condition" do
    subject.visibility_condition = nil
    subject.should validate_presence_of(:visibility_condition)
  end

  it "responds to" do
    should respond_to(:alias, :content, :hidden, :name, :visibility, :visibility_condition,
                              :component, :component_params, :component_theme, :block_position_id)
  end

end
