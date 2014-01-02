# Devise G5 Authenticatable

[![Build Status](https://circleci.com/gh/g5search/devise_g5_authenticatable.png
)](https://circleci.com/gh/g5search/devise_g5_authenticatable)

Devise G5 Authenticatable extends devise to provide an
[OAuth 2.0](http://oauth.net/2)-based authentication strategy and remote 
credential management via [G5 Auth](https://github.com/g5search/g5-authentication).

Devise G5 Authenticatable is intended as a drop-in replacement for the
Database Authenticatable module, in order to support single sign-on for
G5 users.

## Current Version

0.0.1 (unreleased)

## Requirements

* [Devise](https://github.com/plataformatec/devise) ~> 3.1

## Installation

Add this line to your application's Gemfile:

    gem 'devise_g5_authenticatable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_g5_authenticatable

## Usage

TODO: Write usage instructions here

## Examples

TODO: Write examples here

Currently, the best source of example code is in the [test Rails application](spec/dummy) used for integration testing.

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
[file an issue](https://github.com/g5search/devise_g5_authenticatable/issues).

### Specs

Before running the specs for the first time, you will need to initialize the
database for the test Rails application.

```bash
cd spec/dummy
RAILS_ENV=test rake db:setup
```

Execute the entire test suite:

```bash
bundle exec rspec spec
```

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
