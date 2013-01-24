class Block < ActiveRecord::Base
  belongs_to :block_position

  attr_accessible :block_position_id, as: :admin
  attr_accessible :alias, :content, :hidden, :name, as: :admin

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
  def self.view(block)
    content = where(alias: block).visible.first
    if content.present?
      ActionController::Base.helpers.div_for content, :white do
        content.content.html_safe
      end
    end
  end
end
