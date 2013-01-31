# coding: utf-8
class Block < ActiveRecord::Base
  belongs_to :block_position

  attr_accessible :block_position_id, as: :admin
  attr_accessible :alias, :content, :hidden, :name, :visibility, :visibility_condition,
                  :component, :component_params, as: :admin

  validates :alias, presence: true, uniqueness: true
  validates :name, :visibility_condition, presence: true

  before_save :alias_processing

  scope :visible, -> { where(hidden: false) }

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

      pages = block.visibility.delete("^\u{0000}-\u{007F}").split("\r\n")

      search = ''
      # If there are pages for visiblility
      if pages.count > 0
        search = pages.map do |url|
          url.strip!
          # If need all subpages
          if url.last == '*'
            "^\/#{url[0..-2]}"
            # If need root page
          elsif url == '<front>'
            "^\/$"
            # If need particular page
          elsif url.present?
            "^\/#{url}$"
          end
        end.join('|')
        search.gsub!(/\//, '\/') if search.present?
      end

      condition = if search.length == 0
                    true
                  elsif block.visibility_condition == 'except'
                    path !~ /#{search.presence}/
                  else
                    path =~ /#{search.presence}/
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
    class_name = "#{block.component.camelize}Component"
    if class_exists?(class_name)
      component_params = block.component_params.delete(' ').delete("^\u{0000}-\u{007F}").split(/\r\n/).map do |param|
        param = param.split(':')
        param[0] = param.first.to_sym
        param
      end
      component = eval(class_name).new(Hash[component_params])
      component.main
      #{vars: component.vars, block: block}
      vars = component.instance_values
      vars[:block] = block
      vars.keys.each do |key|
        vars[(key.to_sym rescue key) || key] = vars.delete(key)
      end
      vars
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
