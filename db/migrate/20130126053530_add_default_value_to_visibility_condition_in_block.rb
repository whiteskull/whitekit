class AddDefaultValueToVisibilityConditionInBlock < ActiveRecord::Migration
  def change
    change_column_default :blocks, :visibility_condition, 'only'
  end
end
