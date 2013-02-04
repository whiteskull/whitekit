class AddComponentThemeToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :component_theme, :string
  end
end
