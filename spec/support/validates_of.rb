module ValidatesOf
  class Matcher
    def initialize(attribute, error_message, type)
      @attribute = attribute
      @error_message = error_message
      @type = type
    end

    def matches?(model)
      @model = model
      @model.valid?
      @model.errors[@attribute].any? { |error| error == @error_message }
    end

    def with_message(error_message)
      @error_message = error_message
      self
    end

    def failure_message
      "#{@model.class} failed of validate :#@attribute #@type."
    end

    def negative_failure_message
      "#{@model.class} validated :#@attribute #@type."
    end
  end

  def validate_presence_of(attribute)
    Matcher.new(attribute, "can't be blank", 'presence')
  end

  def validate_uniqueness_of(attribute)
    Matcher.new(attribute, "has already been taken", 'uniqueness')
  end
end