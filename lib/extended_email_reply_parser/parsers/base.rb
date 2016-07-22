module ExtendedEmailReplyParser
  class Parsers::Base
    @@quote_header_regexes ||= []

    attr_accessor :text

    def initialize(text_before_parsing)
      self.text = text_before_parsing

      # The `EmailReplyParser::Email` is extended in this gem.
      # Have a look at:
      #
      #   lib/extended_email_reply_parser/email_reply_parser/email.rb
      #
      @email = EmailReplyParser::Email.new.read(text)
    end

    # This `parse` method of the `Parsers::Base` will be overridden
    # by the individual parsers.
    #
    # The text before parsing is accessed with `text`.
    # The method `parse` is expected to return the parsed text.
    #
    def parse
      return text
    end

    # To avoid cutting off the email within a visible quote, wrap the
    # `hide_everything_after` calls within a `except_in_visible_block_quotes`
    # block:
    #
    #     module ExtendedEmailReplyParser
    #       class Parsers::I18nEn < Parsers::Base
    #         def parse
    #           except_in_visible_block_quotes do
    #             hide_everything_after ["From: ", "Sent: ", "To: "]
    #           end
    #           # ...
    #         end
    #       end
    #     end
    #
    # Otherwise, the following email would be completely cut off after
    # "Hi Chris,".
    #
    #     Hi Chris,
    #
    #     > From: Chris <chris@example.com>
    #     > Sent: Saturday, July 09, 2016 3:27 PM
    #     > To: John <john@example.com>
    #     > Subject: The solution!
    #     >
    #     > Hi John,
    #     > I've just found a solution to our big problem!
    #
    #     this is great, thanks!
    #     Cheers, John
    #
    def except_in_visible_block_quotes(&block)
      @email.except_in_visible_block_quotes(&block)
      return @email.visible_text
    end

    # Boil quote like these
    #
    #    > Hi,
    #
    #    > how are you doing?
    #
    #    > Cheers
    #
    # down to
    #
    #    > Hi,
    #    > how are you doing?
    #    > Cheers
    #
    #
    def remove_empty_lines_between_block_quote_lines
      @email.remove_empty_lines_between_block_quote_lines
      return @email.visible_text
    end

    # Some email clients do not quote the previous conversation.
    #
    #     Hi Chris,
    #     this is great, thanks!
    #     Cheers, John
    #
    #
    #     From: Chris <chris@example.com>
    #     Sent: Saturday, July 09, 2016 3:27 PM
    #     To: John <john@example.com>
    #     Subject: The solution!
    #
    #     Hi John,
    #     I've just found a solution to our big problem!
    #     ...
    #
    # To remove the previous conversation, tell the parser expressions
    # to identify where start of the previous conversation:
    #
    #     module ExtendedEmailReplyParser
    #       class Parsers::I18nEn < Parsers::Base
    #         def parse
    #           except_in_visible_block_quotes do
    #             hide_everything_after ["From: ", "Sent: ", "To: "]
    #           end
    #           # ...
    #         end
    #       end
    #     end
    #
    # The parser will combine the expressions to a regex:
    #     /(#{expressions.join(".*?")}.*?\n)/m`
    # for example:
    #     /(From: .*?Sent: .*?To: .*?\n)/m
    #
    def hide_everything_after(expressions)
      @email.hide_everything_after(expressions)
      return @email.visible_text
    end

    # "On ... wrote:" (English)
    # "Am ... schrieb ...:" (German)
    # ...
    #
    def self.quote_header_regexes
      @@quote_header_regexes
    end

    # The github parser (https://github.com/github/email_reply_parser) needs to
    # know how to identify the header line of quotes, for example
    #
    #     "On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote"
    #
    # Example email:
    #
    #     Hi,
    #
    #     On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote:
    #     > Hi folks
    #     >
    #     > What is the best way to clear a Riak bucket of all key, values after
    #     > running a test?
    #     > I am currently using the Java HTTP API.
    #
    #     You can list the keys for the bucket and call delete for each. Or if you
    #     put the keys (and kept track of them in your test) you can delete them
    #     one at a time (without incurring the cost of calling list first.)
    #
    # By default, the github parser uses the regex `/^On .* wrote:$/` for that.
    # To make it recognize other header lines, specify their patterns using
    # `add_quote_header_regex`.
    #
    # Since this is needed by the github parser, i.e. possibly before the `parse`
    # method of your custom parser is run, make sure to add the quote header
    # regex in the class head:
    #
    #     module ExtendedEmailReplyParser
    #       class Parsers::I18nDe < Parsers::Base
    #         add_quote_header_regex '^Am .* schrieb.*$'
    #         # ...
    #       end
    #     end
    #
    def self.add_quote_header_regex(regex_string)
      @@quote_header_regexes << regex_string
    end

    def self.subclasses
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
