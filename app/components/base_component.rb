# All your components must inheritance from this class
# All your variables must be in VARS hash which can be accessed at view: /app/views/components/{name of component}/_index.haml
# Actions begin with a method main
class BaseComponent
  attr_reader :vars
  cattr_accessor :request

  def initialize(options = {})
    @options = options
    @vars = {}
  end

  def main
  end

  def params
    self.request.parameters
  end
end