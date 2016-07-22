# ExtendedEmailReplyParser

[![Build Status](https://travis-ci.org/fiedl/extended_email_reply_parser.svg?branch=master)](https://travis-ci.org/fiedl/extended_email_reply_parser)

## Usage

There's a convenience method to read in an email file and return a [Mail::Message](https://github.com/mikel/mail/blob/master/lib/mail/message.rb) object.

```ruby
ExtendedEmailReplyParser.read "/path/to/email.eml"  # => Mail::Message
```

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'extended_email_reply_parser'
```

And then execute:

    ➜ bundle

Or install it yourself as:

    ➜ gem install extended_email_reply_parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fiedl/extended_email_reply_parser.


## License

The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).

