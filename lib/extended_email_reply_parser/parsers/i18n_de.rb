module ExtendedEmailReplyParser
  class Parsers::I18nDe < Parsers::Base
    add_quote_header_regex '^Am .* schrieb.*$'

    def parse
      remove_empty_lines_between_block_quote_lines
      except_in_visible_block_quotes do
        hide_everything_after ["Von: ", "Gesendet: ", "An: "]
        hide_everything_after ["Gesendet: ", "Von: ", "An: "]
        hide_everything_after ["Von: ", "An: ", "Gesendet: "]
        hide_everything_after ["Am ", "schrieb "]
      end
    end

  end
end
