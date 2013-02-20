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

  COMPONENT_VIEW = <<-VIEW
-# If you need to use js or css, you can use (they included automatically):
-# assets/(javascripts|stylesheets)/components/COMPONENT_NAME/(theme_name)/COMPONENT_NAME.(js|css)
-# theme_name by default is 'default'. If you change the theme then you have to copy js and css to new folder
-# with name of this theme.
-#
-# You can use all instance variables of the component as regular variables.
-# Also there are special variables:
-# component_path - Path to this component
-# options - Options of this component
-# block - Block parameters of this component

= "[\#{block.name}]"
  VIEW

  # Check if user is admin
  def check_admin
    unless user_signed_in? && current_user.admin?
      abort()
    end
  end

  # POST whitekit/make_aliases
  def make_aliases
    Page.make_aliases

    respond_to do |format|
      format.js
    end
  end

  # Clear all caches
  # POST whitekit/clear_caches
  def clear_caches
    Rails.cache.clear

    # If edit mode on then restart server in production and delete tmp/db folder
    if cookies['whitekit-edit'] == 'on'
      FileUtils.rm_rf Rails.root.join('tmp', 'db')
      restart_path = Rails.root.join('tmp', 'restart.txt')
      FileUtils.rm restart_path if File.exists? restart_path
      FileUtils.touch restart_path
    end

    respond_to do |format|
      format.js
    end
  end

  # POST whitekit/create_component
  def create_component
    component = params[:component_name].strip.downcase.gsub(/ /, '_')
    # If component name not empty, and file does not exist
    if component.present? && !File.exists?(file = Rails.root.join('app', 'components', "#{component}_component.rb").to_s)
      # Create class of component
      File.open(file, 'w') do |f|
        f.write(COMPONENT_CLASS_TEMPLATE.gsub(/COMPONENT_NAME/, component.camelize))
      end
      # Create view of component
      FileUtils.mkdir_p view_dir = Rails.root.join('app', 'views', 'components', component, 'default').to_s
      File.open("#{view_dir}/_index.haml", 'w') do |f|
        f.write(COMPONENT_VIEW.gsub(/COMPONENT_NAME/, component))
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
    data[:content] = Whitekit.read_file(Rails.root.join(params[:path].strip))

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

    cookies[:whitekit_file_type] = data[:type]
    cookies[:whitekit_file_path] = params[:path]
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
    File.open(Rails.root.join(params[:path].strip), 'w+') do |f|
      f.write(params[:content])
    end
    render text: true
  end

  # POST whitekit/db_backup
  def db_backup
    config = Rails.configuration.database_configuration[Rails.env]
    time = Time.now.to_formatted_s(:db).gsub(/-| |:/, '_')
    dir = Rails.root.join('tmp', 'db')

    dump = case config['adapter']
            when 'mysql2'
              file = "#{dir}/db_mysql_#{config['database']}_#{time}.sql"
              "mysqldump --lock-tables=FALSE -h#{config['host']} -u#{config['username']} -p#{config['password']} #{config['database']} > #{file}"
            else
              nil
          end

    if dump
      FileUtils.mkdir_p dir
      if system(dump) == true
        send_file file, type: 'text/plain'
        return
      end
    end

    render text: t('admin.misc.error')
  end

  # POST whitekit/db_recovery
  def db_recovery
    @success = false

    if params[:database]
      config = Rails.configuration.database_configuration[Rails.env]
      name = params[:database].original_filename

      if name.split('.').last =~ /sql/
        dir = Rails.root.join('tmp', 'db')
        FileUtils.mkdir_p dir
        file = "#{dir}/#{name}"
        File.open file, 'wb' do |f|
          f.write(params[:database].read)
        end

        case config['adapter']
          when 'mysql2'
            drop_tables = "mysqldump -u#{config['username']} -p#{config['password']} --add-drop-table --no-data #{config['database']} | grep ^DROP | mysql -u#{config['username']} -p#{config['password']} #{config['database']}"
            if system(drop_tables) == true
              recovery = "mysql -D#{config['database']} -h#{config['host']} -u#{config['username']} -p#{config['password']} < #{file}"
              if system(recovery) == true
                @success = true
              end
            end
          else
            nil
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end
end













