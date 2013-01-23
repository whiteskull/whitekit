class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.string :alias
      t.text :content
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
