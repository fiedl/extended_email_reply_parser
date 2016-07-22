module ExtendedEmailReplyParser
  class Parsers::I18nEn < Parsers::Base

    def parse
      except_in_visible_block_quotes do
        hide_everything_after ["From: ", "Sent: ", "To: "]
      end
    end

  end
end
