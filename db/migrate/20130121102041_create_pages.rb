class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :content
      t.string :alias
      t.string :keywords
      t.text :description
      t.boolean :to_first
      t.string :redirect_to
      t.boolean :hidden, default: false

      t.timestamps
    end
  end
end
