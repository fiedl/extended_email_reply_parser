module ExtendedEmailReplyParser
  class Parsers::Github < Parsers::Base
    add_quote_header_regex '^On .* wrote:$'

    def parse
      EmailReplyParser.parse_reply text
    end

  end
end
