class RemoveBlockIdFromBlockPosition < ActiveRecord::Migration
  def up
    remove_column :block_positions, :block_id
  end

  def down
    add_column :block_positions, :block_id, :integer
  end
end
