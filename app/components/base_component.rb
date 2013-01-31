# All your components must inheritance from this class
# All your instance variables can be accessed at view: /app/views/components/{name of component}/_index.haml
# Actions begin with a method MAIN
class BaseComponent
  cattr_accessor :request, :count

  def initialize(options = {})
    @options = options

    @@count = {} if @@count.nil?

    if @@count.key? self.class.to_s
      @@count[self.class.to_s] += 1
    else
      @@count[self.class.to_s] = 1
    end
  end

  # Starting method for components
  def main
  end

  # Access to params
  def params
    self.request.parameters
  end

  # Merge default options with user options
  def merge(defaults)
    @options = @options.reverse_merge(defaults)
  end

end
