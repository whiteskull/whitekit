class Whitekit::GeneralController < ApplicationController

  skip_before_filter :get_main_menu
  before_filter :check_admin

  COMPONENT_CLASS_TEMPLATE = <<-TEMPLATE
class COMPONENT_NAMEComponent < BaseComponent
  PARAMS_DESCRIPTION = <<-DESCRIPTION
  DESCRIPTION

  def main
  end
end
  TEMPLATE

  # Check if user is admin
  def check_admin
    unless user_signed_in? && current_user.admin?
      abort()
    end
  end

  # POST whitekit/make_aliases
  def make_aliases
    if current_user.try(:admin?)
      Page.make_aliases
    end

    respond_to do |format|
      format.js
    end
  end

  # POST whitekit/clear_caches
  def clear_caches
    @clear = system('rm -rf tmp/cache')

    respond_to do |format|
      format.js
    end
  end

  # POST whitekit/create_component
  def create_component
    component = params[:component_name].downcase.gsub(/ /, '_')
    # If component name not empty, and file does not exist
    if component.present? && !File.exists?(file = Rails.root.join('app', 'components', "#{component}_component.rb").to_s)
      # Create class of component
      File.open(file, 'w') do |f|
        f.write(COMPONENT_CLASS_TEMPLATE.gsub(/COMPONENT_NAME/, component.camelize))
      end
      # Create view of component
      FileUtils.mkdir_p view_dir = Rails.root.join('app', 'views', 'components', component, 'default').to_s
      File.open("#{view_dir}/_index.haml", 'w') do |f|
        f.write('= "[#{block.alias}]"')
      end
      # Create js of component
      FileUtils.mkdir_p js_dir = Rails.root.join('app', 'assets', 'javascripts', 'components', component, 'default').to_s
      File.open("#{js_dir}/#{component}.js.coffee", 'w') do |f|
        f.write('$(document).ready ->')
      end
      # Create style of component
      FileUtils.mkdir_p css_dir = Rails.root.join('app', 'assets', 'stylesheets', 'components', component, 'default').to_s
      File.open("#{css_dir}/#{component}.css.scss", 'w') do |f|
        f.write(".#{component}_block {\r\n}")
      end
      # Create directory in images for component
      FileUtils.mkdir_p Rails.root.join('app', 'assets', 'images', 'components', component, 'default').to_s
      @error = false
    else
      @error = true
    end

    respond_to do |format|
      format.js
    end
  end

  # POST whitekit/get_component_params
  def get_component_params
    class_component = "#{params[:component].camelize}Component"

    if params[:component].present? && defined?(eval(class_component)::PARAMS_DESCRIPTION)
      component_params = eval(class_component)::PARAMS_DESCRIPTION
      render text: component_params
    else
      render text: ''
    end
  end

  # POST whitekit/get_file_content
  def get_file_content
    data = {}
    data[:content] = Whitekit.read_file(params[:path])

    data[:type] = case params[:path]
                    when /\.rb/
                      'ruby'
                    when /\.coffee/
                      'coffee'
                    when /\.js/
                      'javascript'
                    when /\.scss/
                      'scss'
                    when /\.css/
                      'css'
                    else
                      'text'
                  end

    session[:whitekit_file_type] = data[:type]
    session[:whitekit_file_path] = params[:path]
    respond_to do |format|
      format.js {
        render json: data
      }
    end
  end

  # POST whitekit/get_folder_content
  def get_folder_content
    session[:whitekit_path] = "#{session[:whitekit_path].presence}[#{params[:path]}]"
    @path = params[:path]

    render layout: false
  end

  # POST whitekit/session_path
  def session_path
    case params[:mode]
      # Add path to session
      when 'add'
        session[:whitekit_path] = "#{session[:whitekit_path].presence}[#{params[:path]}]"
      # Remove path from session
      when 'remove'
        session[:whitekit_path].gsub!(/\[#{Regexp.escape("#{params[:path]}")}.*?\]/, '') if session[:whitekit_path].present?
    end
    render text: true
  end

  # POST whitekit/save_file_content
  def save_file_content
    File.open(params[:path].strip, 'w+') do |f|
      f.write(params[:content])
    end
    render text: true
  end
end













