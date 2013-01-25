# coding: utf-8
class Block < ActiveRecord::Base
  belongs_to :block_position

  attr_accessible :block_position_id, as: :admin
  attr_accessible :alias, :content, :hidden, :name, :visibility, :visibility_condition, as: :admin

  validates :alias, presence: true, uniqueness: true
  validates :name, presence: true

  before_save :alias_processing

  scope :visible, where(hidden: false)

  private

  # Make alias lower case and replace space to underscore
  def alias_processing
    self.alias = Russian.translit(self.alias.downcase.gsub(' ', '_'))
  end

  # Get block content
  def self.view(block, path)
    content = where(alias: block).visible.first
    get_block(content, path)
  end

  def self.get_block(block, path)
    if block.present?

      if path[1..-1] =~ /^first-page|^third-page/
        ActionController::Base.helpers.div_for block, :white do
          block.content.html_safe
        end
      end
    end
  end
end
