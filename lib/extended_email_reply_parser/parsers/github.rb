module ExtendedEmailReplyParser
  class Parsers::Github < Parsers::Base

    def parse
      EmailReplyParser.parse_reply text
    end

  end
end
