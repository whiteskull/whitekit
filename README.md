# WhiteCMS

## Description of Contents

The default directory structure of a generated Ruby on Rails application:

  |-- app
  |   |-- assets
  |       |-- images
  |       |-- javascripts
  |       `-- stylesheets
  |   |-- controllers
  |   |-- helpers
  |   |-- mailers
  |   |-- models
  |   `-- views
  |       `-- layouts
  |-- config
  |   |-- environments
  |   |-- initializers
  |   `-- locales
  |-- db
  |-- doc
  |-- lib
  |   `-- tasks
  |-- log
  |-- public
  |-- script
  |-- test
  |   |-- fixtures
  |   |-- functional
  |   |-- integration
  |   |-- performance
  |   `-- unit
  |-- tmp
  |   |-- cache
  |   |-- pids
  |   |-- sessions
  |   `-- sockets
  `-- vendor
      |-- assets
          `-- stylesheets
      `-- plugins

app
  Holds all the code that's specific to this particular application.

app/assets
  Contains subdirectories for images, stylesheets, and JavaScript files.

app/controllers
  Holds controllers that should be named like weblogs_controller.rb for
  automated URL mapping. All controllers should descend from
  ApplicationController which itself descends from ActionController::Base.

app/models
  Holds models that should be named like post.rb. Models descend from
  ActiveRecord::Base by default.

app/views
  Holds the template files for the view that should be named like
  weblogs/index.html.erb for the WeblogsController#index action. All views use
  eRuby syntax by default.

app/views/layouts
  Holds the template files for layouts to be used with views. This models the
  common header/footer method of wrapping views. In your views, define a layout
  using the <tt>layout :default</tt> and create a file named default.html.erb.
  Inside default.html.erb, call <% yield %> to render the view using this
  layout.

app/helpers
  Holds view helpers that should be named like weblogs_helper.rb. These are
  generated for you automatically when using generators for controllers.
  Helpers can be used to wrap functionality for your views into methods.

config
  Configuration files for the Rails environment, the routing map, the database,
  and other dependencies.

db
  Contains the database schema in schema.rb. db/migrate contains all the
  sequence of Migrations for your schema.

doc
  This directory is where your application documentation will be stored when
  generated using <tt>rake doc:app</tt>

lib
  Application specific libraries. Basically, any kind of custom code that
  doesn't belong under controllers, models, or helpers. This directory is in
  the load path.

public
  The directory available for the web server. Also contains the dispatchers and the
  default HTML files. This should be set as the DOCUMENT_ROOT of your web
  server.

script
  Helper scripts for automation and generation.

test
  Unit and functional tests along with fixtures. When using the rails generate
  command, template test files will be generated for you and placed in this
  directory.

vendor
  External libraries that the application depends on. Also includes the plugins
  subdirectory. If the app has frozen rails, those gems also go here, under
  vendor/rails/. This directory is in the load path.

## [Rails Admin][rails_admin]

[![Gem Version](https://badge.fury.io/rb/rails_admin.png)][gem]

[gem]: https://rubygems.org/gems/rails_admin
[rails_admin]: https://github.com/sferik/rails_admin

You can enter in administrator back-end
xxx.xx/admin

email: admin@mail.ru
password: password

### Use [CKEditor][ckeditor] field in rails admin

[ckeditor]: https://github.com/galetahub/ckeditor

Add to rails_admin.rb:

```ruby
config.model ModelName do
  edit do
    field :field_name do
      ckeditor do
        true
      end
    end
  end
end

## [Twitter bootstrap][bootstrap]

[bootstrap]: https://github.com/thomas-mcdonald/bootstrap-sass

There is a helper that includes all available javascripts:

    //= require bootstrap

Or you can also load individual modules:

    //= require bootstrap-scrollspy
    //= require bootstrap-modal
    //= require bootstrap-dropdown

And so on...

== [SimpleForm][simple_form]

[simple_form]: https://github.com/plataformatec/simple_form

Example:

```haml
= simple_form_for @user do |f|
  = f.input :username
  = f.input :password
  = f.button :submit
