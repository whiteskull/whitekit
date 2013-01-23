class AddTitleSeoAndTitlePageToPage < ActiveRecord::Migration
  def change
    add_column :pages, :title_seo, :string
    add_column :pages, :title_page, :string
  end
end
