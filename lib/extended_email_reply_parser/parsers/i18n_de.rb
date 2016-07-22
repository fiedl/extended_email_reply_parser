module ExtendedEmailReplyParser
  class Parsers::I18nDe < Parsers::Base

    def parse
      except_in_visible_block_quotes do
        hide_everything_after ["Von: ", "Gesendet: ", "An: "]
        hide_everything_after ["Am ", "schrieb "]
      end
    end

  end
end
