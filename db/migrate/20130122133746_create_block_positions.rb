class CreateBlockPositions < ActiveRecord::Migration
  def change
    create_table :block_positions do |t|
      t.string :name
      t.string :alias
      t.boolean :hidden, default: true
      t.references :block

      t.timestamps
    end
  end
end
