## v1.0.0 (2017-10-19)

* **Backwards incompatible changes**
  * Dropped support for rails < 4.1
  * Dropped support for ruby < 2.2 (older versions *may* continue to work for
  now, but there are no guarantees)
  * Dropped support for devise < 4.3. The breaking change most likely to affect
  users of this gem is the removal of omniauth route helpers with a wildcard
  `:provider` parameter. However, the other forms of omniauth route helpers
  still work. For example, `user_omniauth_authorize_path(:g5)` is no longer
  valid, but you can still use `user_g5_omniauth_authorize_path` (preferred)
  or `omniauth_authorize_path(:user, :g5)`
* Enhancements
  * Added support for ruby 2.3 and 2.4
  * Added support for rails 5.0 and 5.1
* Bug fixes
  * The devise upgrade picked up a number of bug fixes, most notably the
  `FailureApp` nil `script_name` issue introduced in devise 3.5.2, which broke
  route generation within mounted engines (see
  [plataformatec/devise#3705](https://github.com/plataformatec/devise/issues/3705))

## v0.3.0 (2016-11-03)

* Exposes callbacks for more fine-grained control over mapping auth user
  data and roles to local models
  ([#25](https://github.com/G5/devise_g5_authenticatable/pull/25))

## v0.2.4 (2015-12-09)

* Same as v0.2.4.beta but not is a stable version!

## v0.2.4.beta (2015-12-03)

* Enforces uniqueness of email address in when looking for an email without UID

## v0.2.3 (2015-11-30)

* Pins version of devise to 3.5.1 due - https://github.com/plataformatec/devise/issues/3705
* Pins version of omniauth-g5 to v0.3.1 due - https://github.com/G5/omniauth-g5/pull/10

## v0.2.1 (2015-05-28)

* Fixes for compatibility with
  [devise](https://github.com/plataformatec/devise) v3.5.1
  ([#18](https://github.com/G5/devise_g5_authenticatable/issues/18))

## v0.2.0 (2015-01-08)

* Add support for strict token validation, disabled by default
  ([#17](https://github.com/G5/devise_g5_authenticatable/pull/17))

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
