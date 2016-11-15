# ExtendedEmailReplyParser

[![Join the chat at https://gitter.im/fiedl/extended_email_reply_parser](https://badges.gitter.im/fiedl/extended_email_reply_parser.svg)](https://gitter.im/fiedl/extended_email_reply_parser?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/fiedl/extended_email_reply_parser.svg?branch=master)](https://travis-ci.org/fiedl/extended_email_reply_parser) [![Code Climate](https://codeclimate.com/github/fiedl/extended_email_reply_parser/badges/gpa.svg)](https://codeclimate.com/github/fiedl/extended_email_reply_parser) [![Test Coverage](https://codeclimate.com/github/fiedl/extended_email_reply_parser/badges/coverage.svg)](https://codeclimate.com/github/fiedl/extended_email_reply_parser/coverage) [![Gem Version](https://badge.fury.io/rb/extended_email_reply_parser.svg)](https://badge.fury.io/rb/extended_email_reply_parser) [![Dependency Status](https://gemnasium.com/badges/github.com/fiedl/extended_email_reply_parser.svg)](https://gemnasium.com/github.com/fiedl/extended_email_reply_parser) [![Documentation](https://img.shields.io/badge/documentation-rubydoc.info-blue.svg)](http://www.rubydoc.info/github/fiedl/extended_email_reply_parser/)

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

Or, to see where this comes from:

```ruby
ExtendedEmailReplyParser.extract_text message
ExtendedEmailReplyParser.extract_text '/path/to/email.eml'
```

Or, in two separate steps:

```ruby
ExtendedEmailReplyParser.read("/path/to/email.eml")  # => Mail::Message
ExtendedEmailReplyParser.read("/path/to/email.eml").extract_text  # => String
```

**Optional: How to handle html-only emails**: There are emails that do not have a text part but only an html part. For those emails, `ExtendedEmailReplyParser.parse` uses the html part. But, to give you more control over how to handle those situations, `ExtendedEmailReplyParser.extract_text` returns `nil` for those emails. If you want your text extraction to fall back to the html part if the text part is missing, use this:

```ruby
ExtendedEmailReplyParser.extract_text_or_html message
ExtendedEmailReplyParser.extract_text_or_html '/path/to/email.eml'
```

The `Mail::Message` object it self is extended to support `message.extract_text`, `message.extract_html_body_content` as well as `message.extract_text_or_html`.

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

Or, for the edge version:

```ruby
# Gemfile
gem 'extended_email_reply_parser', github: 'fiedl/extended_email_reply_parser'
```

And then execute:

    ➜ bundle

Or install it yourself as:

    ➜ gem install extended_email_reply_parser

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Helper methods for writing parsers

To accomplish the most common parsing operations, there are a couple of helper methods.

This, for example, is the [English parser](lib/extended_email_reply_parser/parsers/i18n_en.rb).

```ruby
module ExtendedEmailReplyParser
  class Parsers::I18nEn < Parsers::Base

    def parse
      except_in_visible_block_quotes do
        hide_everything_after ["From: ", "Sent: ", "To: "]
      end
    end

  end
end
```

#### `add_quote_header_regex`

The [github parser](https://github.com/github/email_reply_parser) needs to know how to identify the header line of quotes, for example "On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote":

    Hi,

    On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote:
    > Hi folks
    >
    > What is the best way to clear a Riak bucket of all key, values after
    > running a test?
    > I am currently using the Java HTTP API.

    You can list the keys for the bucket and call delete for each. Or if you
    put the keys (and kept track of them in your test) you can delete them
    one at a time (without incurring the cost of calling list first.)

By default, it uses the regex `/^On .* wrote:$/` for that. To make it recognize other header lines, specify their patterns using `add_quote_header_regex`.

Since this is needed by the github parser, i.e. possibly before the `parse` method of your custom parser is run, make sure to add the quote header regex in the class head:

```ruby
module ExtendedEmailReplyParser
  class Parsers::I18nDe < Parsers::Base
    add_quote_header_regex '^Am .* schrieb.*$'
    # ...
  end
end
```

#### `hide_everything_after`

Some email clients do not quote the previous conversation.

    Hi Chris,
    this is great, thanks!
    Cheers, John


    From: Chris <chris@example.com>
    Sent: Saturday, July 09, 2016 3:27 PM
    To: John <john@example.com>
    Subject: The solution!

    Hi John,
    I've just found a solution to our big problem!
    ...

To remove the previous conversation, tell the parser expressions to identify where start of the previous conversation:

```ruby
module ExtendedEmailReplyParser
  class Parsers::I18nEn < Parsers::Base
    def parse
      except_in_visible_block_quotes do
        hide_everything_after ["From: ", "Sent: ", "To: "]
      end
      # ...
    end
  end
end
```

(The parser will combine the expressions to a regex: `/(#{expressions.join(".*?")}.*?\n)/m`, for example: `/(From: .*?Sent: .*?To: .*?\n)/m`.)

To avoid cutting off the email within a visible quote, wrap the `hide_everything_after` within a `except_in_visible_block_quotes` block as shown above.

    Hi Chris,

    > From: Chris <chris@example.com>
    > Sent: Saturday, July 09, 2016 3:27 PM
    > To: John <john@example.com>
    > Subject: The solution!
    >
    > Hi John,
    > I've just found a solution to our big problem!

    this is great, thanks!
    Cheers, John

If not wrapped in `except_in_visible_block_quotes`, the parsed email would just be "Hi Chris,", because everything after "From: Sent: To:" would be cut off.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fiedl/extended_email_reply_parser.


## License

The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).

