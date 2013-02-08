require 'spec_helper'

describe BlockPosition do

  it "responds to" do
    should respond_to(:alias, :hidden, :name)
  end

  it "only admin can create a block position" do
    expect { BlockPosition.create!({name: 'New block position', alias: 'block_position'}) }.to raise_error
    expect { BlockPosition.create!({name: 'New block position', alias: 'block_position'}, as: :admin) }.to_not raise_error
  end

  it "name should be presence" do
    block = BlockPosition.new({alias: 'block_postion'}, as: :admin)
    block.should be_invalid
    block.name = 'My new block'
    block.should be_valid
  end

  it "alias should be presence" do
    block = BlockPosition.new({name: 'New block position'}, as: :admin)
    block.should be_invalid
    block.alias = 'block_position'
    block.should be_valid
  end

  it "should have unique alias" do
    BlockPosition.create({name: 'New block position', alias: 'block_position'}, as: :admin)
    block_position = BlockPosition.new({name: 'New block position', alias: 'block_position'}, as: :admin)
    block_position.should be_invalid
    block_position.alias = 'another_block_position'
    block_position.should be_valid
  end

  it "should have correct alias" do
    block_pos = BlockPosition.create({name: 'New block position'}, as: :admin)
    block_pos.alias = '  BLockPos109 -!@#$%^&*()[].,/vERy_*+nEW    '
    block_pos.save
    block_pos.alias.should eql 'blockpos_very_new'
  end

end
