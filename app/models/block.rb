# coding: utf-8
class Block < ActiveRecord::Base
  belongs_to :block_position

  attr_accessible :block_position_id, as: :admin
  attr_accessible :alias, :content, :hidden, :name, :visibility, :visibility_condition, :component, as: :admin

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
  def self.get(block, path)

    # If given alias then get block
    if block.is_a?(Symbol)
      block = where(alias: block).visible.first
    end

    if block.present?

      pages = block.visibility.delete("^\u{0000}-\u{007F}").split("\r\n").unshift('')

      search = ''
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
        search.gsub!(/\//, '\/') if search.present?
      end

      condition = if search.length == 0
                    true
                  elsif block.visibility_condition == 'except'
                    path !~ /#{search[1..-1].presence}/
                  else
                    path =~ /#{search[1..-1].presence}/
                  end

      # Get block content or component if it visible
      if condition
        if block.component.present?
          get_component(block)
        else
          block
        end
      end

    end

  end

  # Get component
  def self.get_component(block)
    class_name = "#{block.component.capitalize}Component"
    if class_exists?(class_name)
      component = eval(class_name).new
      component.main
      {components: block.component.downcase, vars: component.vars, block: block}
    end
  end

  # Check if class of component exists
  def self.class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end
end
