## v0.1.3 (2014-12-19)

* Fix sign out when there isn't a locally authenticated user
  ([#16](https://github.com/G5/devise_g5_authenticatable/pull/16)).

## v0.1.2 (2014-08-04)
* Use existing user with updated password on duplicate user creation with
  duplicate email.

## v0.1.1 (2014-07-31)
* Find a user by email when a duplicate email exception is returned from 
  user creation.

## v0.1.0 (2014-03-12)

* Move `rake g5:export_users` from
  [omniauth-g5](https://github.com/g5search/omniauth-g5)
* First open source release to [RubyGems](https://rubygems.org)

## v0.0.4 (2014-02-26)

* Use the main app's root path (necessary when mounted inside another Rails
  engine with `isolate_namespace`)

## v0.0.3 (2014-02-10)

* Bug fix: fix type conversion errors against PostgreSQL. Assume that model
`provider` and `uid` are stored as strings.

## v0.0.2 (2014-02-05)

* Bug fix: conditionally require model-level mass assignment logic
  (e.g. `attr_accessible`) so that the gem can be used in either Rails 3.2 or
  Rails 4.

## v0.0.1 (2014-02-04)

* Initial release
