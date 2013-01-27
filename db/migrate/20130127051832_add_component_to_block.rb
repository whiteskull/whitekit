class AddComponentToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :component, :text
  end
end
