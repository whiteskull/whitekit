require 'i18n'
I18n.default_locale = :en

# RailsAdmin config file. Generated on January 21, 2013 10:20
# See github.com/sferik/rails_admin for more informations

GEM_COMPONENTS = %W(news slider)

RailsAdmin.config do |config|

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = %w(WhiteKit Admin)
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  config.attr_accessible_role { :admin }

  config.authorize_with do
    redirect_to main_app.root_path unless current_user.try(:admin?)
  end

  config.actions do
    # root actions
    dashboard                     # mandatory
                                  # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
                                  # member actions
    show
    edit
    delete
    history_show
    show_in_app do
      visible do
        %w(Page).include? bindings[:abstract_model].model_name
      end
      controller do
        Proc.new do
          if @object.alias.present?
            redirect_to main_app.page_path(@object.alias)
          else
            redirect_to main_app.root_url
          end
        end
      end
    end

    # Add the nestable action for each model
    nestable do
      visible do
        %w(Page Block SliderImage).include? bindings[:abstract_model].model_name
      end
    end
  end

  config.audit_with :history, User

  config.excluded_models = %w(Ckeditor::Asset Ckeditor::AttachmentFile Ckeditor::Picture)

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['User']

  # Include specific models (exclude the others):
  # config.included_models = ['User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Setting page model
  config.model Page do
    weight 1
    nestable_tree({ position_field: :position, max_depth: 6 })
    list do
      field :id
      field :title
      field :content do
        formatted_value do
          ActionController::Base.helpers.strip_tags(value)
        end
      end
      field :updated_at
      field :hidden do
        column_width 70
      end
    end
    edit do
      field :title
      field :title_page
      field :content do
        ckeditor do
          true
        end
      end
      group :links do
        label I18n.t('admin.group_fields.links')
        active false
        field :link do
          help I18n.t('admin.help.link')
          visible do
            value != '/'
          end
        end
        field :alias do
          help false
          visible do
            !value.nil?
          end
        end
      end
      group :actions do
        label I18n.t('admin.group_fields.actions')
        active false
        field :to_first
        field :redirect_to
        field :hidden
      end
      group :head do
        label I18n.t('admin.group_fields.head')
        active false
        field :title_seo
        field :keywords
        field :description
      end
      exclude_fields :position, :ancestry
    end
  end

  # Setting block position model
  config.model BlockPosition do
    weight 2
    navigation_label I18n.t('admin.misc.navigation_blocks')
    list do
      field :id do
        column_width 40
      end
      fields :name, :alias
      field :hidden do
        column_width 70
      end
    end
    edit do
      include_all_fields
      field :blocks do
        help false
        visible do
          value.present?
        end
      end
    end
  end

  # Setting block model
  config.model Block do
    weight 3
    parent BlockPosition
    nestable_list true
    list do
      field :id do
        column_width 40
      end
      field :name
      field :alias
      field :content do
        formatted_value do
          ActionController::Base.helpers.strip_tags(value)
        end
      end
      field :component
      field :updated_at
      field :hidden do
        column_width 70
      end
    end
    edit do
      include_all_fields
      field :content do
        ckeditor do
          true
        end
      end
      group :components do
        label I18n.t('admin.group_fields.component')
        active false
        field :component, :enum do
          enum do
            component = Dir[Rails.root.join('app', 'components', '*_component.rb').to_s].map do |file|
              file.split('_component').first.split('/').last
            end
            component.delete('base')
            GEM_COMPONENTS.each do |name|
              component << name if Whitekit.class_exists?("#{name.camelize}Component")
            end
            component
          end
        end
        field :component_params
        field :component_theme
      end
      group :visibility do
        label I18n.t('admin.group_fields.visibility')
        active false
        field :visibility_condition, :enum do
          enum do
            {I18n.t('admin.fields_values.block.visible_condition.only') => 'only', I18n.t('admin.fields_values.block.visible_condition.except') => 'except'}
          end
        end
        field :visibility
      end
      exclude_fields :position
    end
  end

  # Setting user model
  config.model User do
    weight 10
    navigation_label I18n.t('admin.misc.navigation_users')
    list do
      exclude_fields :reset_password_sent_at, :remember_created_at, :current_sign_in_at
    end
    edit do
      fields :email, :password, :password_confirmation, :admin
    end
  end

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :admin, :boolean 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
