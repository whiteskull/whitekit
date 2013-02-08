require 'spec_helper'

describe Block do

  it "responds to" do
    should respond_to(:alias, :content, :hidden, :name, :visibility, :visibility_condition,
                              :component, :component_params, :component_theme, :block_position_id)
  end

  it "only admin can create a block" do
    expect { Block.create!({name: 'New block', alias: 'new_block'}) }.to raise_error
    expect { Block.create!({name: 'New block', alias: 'new_block'}, as: :admin) }.to_not raise_error
  end

  it "name should be presence" do
    block = Block.new({alias: 'new_block'}, as: :admin)
    block.should be_invalid
    block.name = 'New block'
    block.should be_valid
  end

  it "alias should be presence" do
    block = Block.new({name: 'New block'}, as: :admin)
    block.should be_invalid
    block.alias = 'new_block'
    block.should be_valid
  end

  it "should have unique alias" do
    Block.create({name: 'New block', alias: 'block'}, as: :admin)
    block = Block.new({name: 'New block', alias: 'block'}, as: :admin)
    block.should be_invalid
    block.alias = 'another_block'
    block.should be_valid
  end

  it "should have correct alias" do
    block = Block.create({name: 'New block'}, as: :admin)
    block.alias = '  BLock109 -!@#$%^&*()[].,/vERy_*+nEW    '
    block.save
    block.alias.should eql 'block_very_new'
  end

end
