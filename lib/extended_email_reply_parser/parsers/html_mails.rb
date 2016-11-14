module ExtendedEmailReplyParser
  class Parsers::HtmlMails < Parsers::Base

    def parse
      except_in_visible_block_quotes do
        hide_everything_after ["<div name=\"quote\""]
      end
    end

  end
end
