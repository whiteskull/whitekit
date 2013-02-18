class ChangeDefaultHiddenFromBlockPosition < ActiveRecord::Migration
  def up
    change_column_default :block_positions, :hidden, false
  end

  def down
    change_column_default :block_positions, :hidden, true
  end
end
