class BlockPosition < ActiveRecord::Base
  has_many :blocks

  attr_accessible :alias, :hidden, :name, as: :admin

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
        if block.content.present?
          content_html << ActionController::Base.helpers.div_for(block) do
            block.content.html_safe
          end
        end
      end
      ActionController::Base.helpers.div_for block_position do
        content_html.html_safe
      end
    end
  end
end
