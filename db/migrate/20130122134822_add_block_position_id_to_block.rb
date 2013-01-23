class AddBlockPositionIdToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :block_position_id, :integer
  end
end
