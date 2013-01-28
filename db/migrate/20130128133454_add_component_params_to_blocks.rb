class AddComponentParamsToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :component_params, :text
  end
end
