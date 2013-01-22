class RemoveNameFromPage < ActiveRecord::Migration
  def up
    remove_column :pages, :name
  end

  def down
    add_column :pages, :name, :string
  end
end
