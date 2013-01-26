# coding: utf-8
class Block < ActiveRecord::Base
  belongs_to :block_position

  attr_accessible :block_position_id, as: :admin
  attr_accessible :alias, :content, :hidden, :name, :visibility, :visibility_condition, as: :admin

  validates :alias, presence: true, uniqueness: true
  validates :name, :visibility_condition, presence: true

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

      pages = block.visibility.delete("^\u{0000}-\u{007F}").split("\r\n").unshift('')

      if pages.count > 1
        search = pages.inject do |sum, str|
          str.strip!
          reg = if str.last == '*'
                  "|^\/#{str[0..-2]}"
                elsif str == '<front>'
                  "|^\/$"
                elsif str.present?
                  "|^\/#{str}$"
                end
          sum += reg ? reg : ''
        end
        search.gsub!(/\//, '\/')[1..-1] if search.present?
      end

      condition = if block.visibility_condition == 'except'
                    path !~ /#{search.presence}/
                  else
                    path =~ /#{search.presence}/
                  end

      if condition
        ActionController::Base.helpers.div_for block, :white do
          block.content.html_safe
        end
      end

    end
  end
end
