# All your components must inheritance from this class
# All your instance variables can be accessed at view: /app/views/components/{name of component}/_index.haml
# Actions begin with a method MAIN
class BaseComponent
  cattr_accessor :request

  def initialize(options = {})
    @options = options
  end

  def main
  end

  def params
    self.request.parameters
  end
end
