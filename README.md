# ExtendedEmailReplyParser

[![Build Status](https://travis-ci.org/fiedl/extended_email_reply_parser.svg?branch=master)](https://travis-ci.org/fiedl/extended_email_reply_parser) [![Code Climate](https://codeclimate.com/github/fiedl/extended_email_reply_parser/badges/gpa.svg)](https://codeclimate.com/github/fiedl/extended_email_reply_parser) [![Test Coverage](https://codeclimate.com/github/fiedl/extended_email_reply_parser/badges/coverage.svg)](https://codeclimate.com/github/fiedl/extended_email_reply_parser/coverage) [![Gem Version](https://badge.fury.io/rb/extended_email_reply_parser.svg)](https://badge.fury.io/rb/extended_email_reply_parser)

When implementing a "reply or comment by email" feature, it's neccessary to filter out signatures and the previous conversation. One needs to extract just the relevant parts for the conversation or comment section of the application. This is what this [ruby](https://www.ruby-lang.org) gem helps to do.

This gem is an extended version of [github's `email_reply_parser`](https://github.com/github/email_reply_parser). It wraps the original email_reply_parser and allows to build extensions such as support for i18n and detecting previous conversation that is not properly marked as quotation by the sender's mail client.

## Usage

### Parsing incoming emails

To extract the relevant text of an email reply, call `ExtendedEmailReplyParser.parse`, which accepts either a path to the email file, or a `Mail::Message` object, or the email body text itself, and returns the parsed, i.e. relevant text, which can be used as comment in the application

```ruby
ExtendedEmailReplyParser.parse "/path/to/email.eml"
ExtendedEmailReplyParser.parse message
ExtendedEmailReplyParser.parse body_text             # => parsed text as String
```

Or, if you prefer to call `#parse` on the `Mail::Message`:

```ruby
message.parse  # => parsed text as String
```

For example, for a incoming `Mail::Message`, `message`:

```ruby
@comment.author = User.where(email: message.from.first).first
@comment.text = ExtendedEmailReplyParser.parse message
@comment.save!
```

### Extracting the body text

This gem extends [Mail::Message](https://github.com/mikel/mail/blob/master/lib/mail/message.rb) to  conveniently extract the text body as utf-8.

```ruby
message.extract_text
```

There's also a convenience method to extract the body text from an email file:

```ruby
ExtendedEmailReplyParser.read "/path/to/email.eml"  # => Mail::Message
ExtendedEmailReplyParser.read("/path/to/email.eml").extract_text  # => String
```

### Writing a parser

The parsing system allows you to add your own parser to the parsing chain. Just define a class inheriting from `ExtendedEmailReplyParser::Parsers::Base` and implement a `parse` method. The text before parsing is accessed via `text`.

```ruby
# app/models/email_parsers/my_parser.rb
class EmailParsers::ShoutParser < ExtendedEmailReplyParser::Parsers::Base

  # This parser SHOUTS THE WHOLE EMAIL.
  # The text before parsing is accessed by `text`.
  #
  def parse
    text.upcase
  end
end
```

### Selecting parsers to use

By default, all parsers that inherit from `ExtendedEmailReplyParser::Parsers::Base` are used. One simply has to call:

```ruby
ExtendedEmailReplyParser.parse message
```

In order to select specific parsers, just chain them yourself:

```ruby
EmailParsers::ShoutParser.parse \
  ExtendedEmailReplyParser::Parsers::Github.parse \
  message
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

