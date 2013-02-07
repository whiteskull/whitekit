Rails.application.config.generators do |g|
  g.stylesheet_engine = :scss
  g.javascript_engine = :coffee
  g.template_engine = :haml
  g.test_framework = :rspec
end
