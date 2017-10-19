# Devise G5 Authenticatable

Devise G5 Authenticatable extends devise to provide an
[OAuth 2.0](http://oauth.net/2)-based authentication strategy and remote
credential management via the G5 Auth service.

Devise G5 Authenticatable is intended as a drop-in replacement for the
Database Authenticatable module, in order to support single sign-on for
G5 users.

## Current Version

1.0.0

## Requirements

* [Ruby](https://github.com/ruby/ruby) >= 2.2
* [Rails](https://github.com/rails/rails) >= 4.1
* [Devise](https://github.com/plataformatec/devise) ~> 4.3

## Installation

Add this line to your application's Gemfile:

    gem 'devise_g5_authenticatable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_g5_authenticatable

## Usage

### Registering your OAuth application

1. Visit the [auth server admin console](https://auth.g5search.com/admin)
   and login.
2. Click "New Application"
3. Enter a name that recognizably identifies your application.
4. Enter the redirect URI where the auth server should redirect
   after the user successfully authenticates. It will generally be
   of the form `http://<apphost>/<devise_path>/auth/g5/callback`.

   For non-production environments, this redirect URI does not have to
   be publicly accessible, but it must be accessible from the browser
   where you will be testing (so using something like
   http://localhost:3000/users/auth/g5/callback is fine if your browser
   and client application server are both local).
5. For a trusted G5 application, check the "Auto-authorize?" checkbox. This
   skips the OAuth authorization step where the user is prompted to explicitly
   authorize the client application to access the user's data.
6. Click "Submit" to obtain the client application's credentials.

### Environment variables

Once you have your OAuth 2.0 credentials, you'll need to set the following
environment variables for your client application:

* `G5_AUTH_CLIENT_ID` - the OAuth 2.0 application ID from the auth server
* `G5_AUTH_CLIENT_SECRET` - the OAuth 2.0 application secret from the auth server
* `G5_AUTH_REDIRECT_URI` - the OAuth 2.0 redirect URI registered with the auth server
* `G5_AUTH_ENDPOINT` - the endpoint URL for the G5 auth server

### Configuration

In `config/initializers/devise.rb`, add the following to enable authentication:

```ruby
Devise.setup do |config|
  # ...
  config.omniauth :g5, ENV['G5_AUTH_CLIENT_ID'], ENV['G5_AUTH_CLIENT_SECRET'],
              client_options: {site: ENV['G5_AUTH_ENDPOINT']}
end
```

Create `config/initializers/g5_auth.rb` with the following:

```ruby
G5AuthenticationClient.configure do |defaults|
  defaults.client_id = ENV['G5_AUTH_CLIENT_ID']
  defaults.client_secret = ENV['G5_AUTH_CLIENT_SECRET']
  defaults.redirect_uri = ENV['G5_AUTH_REDIRECT_URI']
  defaults.endpoint = ENV['G5_AUTH_ENDPOINT']
end
```

### Controller filters and helpers

To require authentication for a controller, use one of devise's generated
before_actions. For example:

```ruby
before_action :authenticate_user!
```

All of [devise's controller helpers](https://github.com/plataformatec/devise#controller-filters-and-helpers)
are available inside a controller. To access the model for the signed-in user:

```ruby
current_user
```

To check if there is a user signed in:

```ruby
user_signed_in?
```

To access the scoped session:

```ruby
user_session
```

### Route helpers

This gem will generate devise's usual route helpers for session management.
For example, if you have configured devise with a `:user` scope, you will have
the following helpers:

```ruby
new_user_session_path
new_session_path(:user)

destroy_user_session_path
destroy_session_path(:user)
```

The gem also provides routes for OmniAuth's integration points, although you
will rarely need to call these directly:

```ruby
user_g5_authorize_path
g5_authorize_path(:user)

user_g5_callback_path
g5_callback_path(:user)
```

### Configuring the model

In your User model (or whatever model you've configured for use with devise):

```ruby
class User < ActiveRecord::Base
  devise :g5_authenticatable # plus whatever other devise modules you'd like
end
```

Several callbacks are provided in order to hook in your application-specific
logic for mapping the auth data to your User model. These methods will be
executed whenever a user logs in.

In order to set simple user attributes based on auth data, override the
`attributes_from_auth` method. Call `super` when you do so in order to pick
up the minimum set of required user attributes:

```ruby
class User < ActiveRecord::Base
  devise :g5_authenticatable

  def attributes_from_auth(auth_data)
    super(auth_data).merge({
      name: "#{auth_data.info.first_name} #{auth_data.info.last_name}"
    })
  end
end
```

If you want to customize the logic for mapping auth role data (which is
ignored by default), override the `update_roles_from_auth` method:

```ruby
class User < ActiveRecord::Base
  devise :g5_authenticatable

  def update_roles_from_auth(auth_data)
    auth_data.extra.roles.each do |r|
      # Your custom logic here, for example...
      add_role(role.name, role.type, role.urn)
    end
  end
end
```

See the [omniauth-g5 documentation](https://github.com/G5/omniauth-g5#auth-hash)
for the structure of the auth data.

### Configuring a custom controller

You can use `devise_for` to hook in a custom controller in your routes,
[the same way as devise](https://github.com/plataformatec/devise#configuring-controllers):

```ruby
devise_for :admins, controllers: {sessions: 'admins/sessions'}
```

If you need to override the sessions controller, remember to extend the correct
base class:

```ruby
class Admins::SessionsController < DeviseG5Authenticatable::SessionsController
end
```

### Strong Parameters

If installed in a Rails 4 application, this gem will automatically use
[devise's parameter sanitizer](https://github.com/plataformatec/devise#strong-parameters)
logic. Under Rails 3.2.x, it will make the appropriate calls to
`attr_accessible` in the model.

If you are using Rails 4 in conjunction with the
[protected_attributes](https://github.com/rails/protected_attributes) gem, you
will need to insert the following in your `config/initializers/devise.rb`:

```ruby
require 'devise_g5_authenticatable/models/protected_attributes'
```

### Token validation

After a user authenticates, their access token will be stored on the G5
Authenticatable model. By default, this token will not be validated against
the auth server again until the local session is destroyed, either because
it times out, or because the user explicitly logs out of the local application.

In order to implement single sign-out, you can enable strict token validation.
This will validate the token against the auth server on every request, and
automatically destroy the local session if the token is no longer valid.

In your `config/initializers/devise.rb':

```ruby
Devise.setup do |config|
  # ...
  config.g5_strict_token_validation = true
end
```

Note that strict token validation incurs a non-trivial amount of performance
overhead, which is why it is disabled by default.

## Examples

Currently, the best source of example code is in the [test Rails
application](spec/dummy) used for integration testing.

## Authors

 * Maeve Revels / [@maeve](https://github.com/maeve)

## Contributing

1. Fork it
2. Get it running (see Installation above)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/devise_g5_authenticatable/issues).

### Specs

Before running the specs for the first time, you will need to initialize the
database for the test Rails application:

    $ cp spec/dummy/config/database.yml.sample spec/dummy/config/database.yml
    $ RAILS_ENV=test bundle exec rake app:db:setup


To execute the entire test suite:

    $ bundle exec rspec spec

## License

Copyright (c) 2013 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
