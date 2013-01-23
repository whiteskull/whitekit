class BlockPosition < ActiveRecord::Base
  has_many :blocks

  attr_accessible :alias, :hidden, :name

  validates :alias, presence: true, uniqueness: true
  validates :name, presence: true

  before_save :alias_processing

  scope :visible, where(hidden: false)

  private

  # Make alias lower case and replace space to underscore
  def alias_processing
    self.alias = Russian.translit(self.alias.downcase.gsub(' ', '_'))
  end

  # Get blocks
  def self.view(position)
    block_position = where(alias: position).visible.first
    if block_position.present?
      blocks = block_position.blocks.visible
      content_html = ''
      blocks.each do |block|
        content_html << block.content if block.content.present?
      end
      content_html.html_safe
    end
  end
end
