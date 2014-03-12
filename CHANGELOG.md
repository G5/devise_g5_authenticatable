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
