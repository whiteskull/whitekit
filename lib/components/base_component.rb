# All your components must inheritance from this class
# All your variables must be in VARS hash which can be accessed at view: /app/views/components/{name of component}/_index.haml
# Actions begin with a method main
class BaseComponent
  attr_reader :vars

  def initialize
    @vars = {}
  end

  def main
  end
end