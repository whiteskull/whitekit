# WhiteKit

## Starting

First you need to download **WhiteKit**

```bash
$ git clone git@github.com:whiteskull/whitekit.git
```

Then you need to install gems

```bash
$ cd whitekit
$ bundle install
```

After install gems you need to create database and load basic data

```bash
$ rake db:setup
```
That's it! Now you can start the server

## Description of Contents

The default directory structure application:

```
|-- app    > Holds all the code that's specific to this particular application.
|   |-- assets    > Contains subdirectories for images, stylesheets, and JavaScript files.
|   |   |-- images
|   |     `-- components    > Better place for your images of component
|   |   |-- javascripts    > Use CoffeeScript by default.
|   |     `-- components    > Place for your javascripts of component
|   |   `-- stylesheets    > Use SCSS by default.
|   |     `-- components    > Place for your stylesheets of component
|   |-- components    > Holds your own components that should be named like slider_component.rb and
|   |                   should be inherited from BaseComponent
|   |-- controllers    > Holds controllers that should be named like weblogs_controller.rb for automated URL mapping.
|   |                    All controllers should descend from ApplicationController.
|   |-- helpers    > Holds view helpers that should be named like weblogs_helper.rb. These are
|   |                generated for you automatically when using generators for controllers.
|   |                Helpers can be used to wrap functionality for your views into methods.
|   |-- mailers
|   |-- models    > Holds models that should be named like post.rb. Models descend from ActiveRecord::Base by default.
|   `-- views    > Holds the template files for the view that should be named like weblogs/index.html.haml
|       |          for the WeblogsController#index action. All views use Haml syntax by default.
|       |-- components    > Place for your views of component
|       `-- layouts    > Holds the template files for layouts to be used with views. This models the
|                        common header/footer method of wrapping views. In your views, define a layout
|                        using the 'layout :default' and create a file named default.html.erb.
|                        Inside default.html.haml, call = yield to render the view using this layout.
|-- config    > Configuration files for the Rails environment, the routing map, the database, and other dependencies.
|   |-- environments
|   |-- initializers
|   `-- locales
|-- db    > Contains the database schema in schema.rb and seed.rb for load data to database
|   `-- migrate    > Contains all the sequence of Migrations for your schema.
|-- doc    > This directory is where your application documentation will be stored when generated using rake doc:app
|-- lib    > Application specific libraries. Basically, any kind of custom code that doesn't belong under controllers,
|   |        models, or helpers. This directory is in the load path.
|   `-- tasks
|-- log
|-- public    > The directory available for the web server. Also contains the dispatchers and the
|               default HTML files. This should be set as the DOCUMENT_ROOT of your web server.
|-- script    > Helper scripts for automation and generation.
|-- spec    > Rspec tests
|   |-- controllers
|   |-- factories
|   |-- features
|   |-- helpers
|   |-- models
|   `-- support
|-- tmp
|   |-- cache
|   |-- pids
|   |-- sessions
|   `-- sockets
`-- vendor    > External libraries that the application depends on. Also includes the plugins subdirectory
    |-- assets
    |   `-- stylesheets
    `-- plugins
```

## The administrative back-end is based on [Rails Admin][rails_admin]

[![Gem Version](https://badge.fury.io/rb/rails_admin.png)][gem]

[gem]: https://rubygems.org/gems/rails_admin
[rails_admin]: https://github.com/sferik/rails_admin

You can enter in administrator back-end

    xxx.xx/admin

```text
email: admin@mail.com
password: password
```

### I18n rails admin

In file **config/initializers/rails_admin.rb** change language key (default :en)

```ruby
I18n.default_locale = :en
```

### Use [CKEditor][ckeditor] field in rails admin

[ckeditor]: https://github.com/galetahub/ckeditor

Add to **rails_admin.rb**

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
```

## [Twitter bootstrap][bootstrap]

[bootstrap]: https://github.com/thomas-mcdonald/bootstrap-sass

There is a helper that includes all available javascripts:

    //= require bootstrap

Or you can also load individual modules:

    //= require bootstrap-scrollspy
    //= require bootstrap-modal
    //= require bootstrap-dropdown

And so on...

## [SimpleForm][simple_form]

[simple_form]: https://github.com/plataformatec/simple_form

Example:

```haml
= simple_form_for @user do |f|
  = f.input :username
  = f.input :password
  = f.button :submit
```
