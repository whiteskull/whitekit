class WhitekitNewsCreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.boolean :hidden, default: false
      t.string :image

      t.timestamps
    end
  end
end
