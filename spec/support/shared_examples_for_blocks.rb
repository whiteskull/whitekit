shared_examples_for "blocks" do |object|

  context "validate" do

    it "presence of name" do
      subject.name = nil
      subject.should validate_presence_of(:name)
    end

    it "presence of alias" do
      subject.alias = nil
      subject.should validate_presence_of(:alias)
    end

    it "uniqueness of alias" do
      params = {name: 'New object', alias: 'object'}
      object.update_attributes(params, as: :admin)
      subject.assign_attributes(params, as: :admin)
      subject.should validate_uniqueness_of(:alias)
    end

  end

  it "only admin can create a block" do
    params = {name: 'New object', alias: 'new_object'}
    expect { subject.assign_attributes(params) }.to raise_error
    expect { subject.assign_attributes(params, as: :admin) }.to_not raise_error
  end

  it "should have correct alias" do
    subject.update_attributes({name: 'New object', alias: '  OBjecT109 -!@#$%^&*()[].,/vERy_*+nEW    '}, as: :admin)
    subject.alias.should eq 'object_very_new'
  end

end