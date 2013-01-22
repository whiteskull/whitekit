class AddAncestryAndPositionToPage < ActiveRecord::Migration
  def change
    add_column :pages, :ancestry, :string
    add_column :pages, :position, :integer
  end
end
