class White::GeneralController < ApplicationController

  COMPONENT_CLASS_TEMPLATE = <<-TEMPLATE
class COMPONENT_NAMEComponent < BaseComponent
  def main
  end
end
  TEMPLATE

  # POST white/make_aliases
  def make_aliases
    if current_user.try(:admin?)
      Page.make_aliases
    end

    respond_to do |format|
      format.js
    end
  end

  # POST white/clear_caches
  def clear_caches
    @clear = system('rm -rf tmp/cache')

    respond_to do |format|
      format.js
    end
  end

  # POST white/create_component
  def create_component
    component = params[:component_name].downcase
    # If component name not empty, and file does not exist
    if component.present? && !File.exists?(file = Rails.root.join('lib', 'components', "#{component}_component.rb").to_s)
      # Create class of component
      File.open(file, 'w') do |f|
        f.write(COMPONENT_CLASS_TEMPLATE.gsub(/COMPONENT_NAME/, component.capitalize))
      end
      # Create view of component
      FileUtils.mkdir view_dir = Rails.root.join('app', 'views', 'components', component).to_s
      File.open("#{view_dir}/_index.haml", 'w') do |f|
        f.write('= "[#{block.alias}]"')
      end
      # Create js of component
      FileUtils.mkdir js_dir = Rails.root.join('app', 'assets', 'javascripts', 'components', component).to_s
      File.open("#{js_dir}/#{component}.js.coffee", 'w') do |f|
        f.write('$(document).ready ->')
      end
      # Create style of component
      FileUtils.mkdir css_dir = Rails.root.join('app', 'assets', 'stylesheets', 'components', component).to_s
      File.open("#{css_dir}/#{component}.css.scss", 'w') do |f|
        f.write(".#{component}_block {\r\n}")
      end
      # Create directory in images for component
      FileUtils.mkdir Rails.root.join('app', 'assets', 'images', 'components', component).to_s
      @error = false
    else
      @error = true
    end

    respond_to do |format|
      format.js
    end
  end
end
