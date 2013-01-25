class AddVisibilityAndVisibilityConditionToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :visibility, :text
    add_column :blocks, :visibility_condition, :string
  end
end
