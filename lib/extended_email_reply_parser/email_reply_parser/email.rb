class EmailReplyParser
  class Email
    def hide_everything_after(expressions)
      split_regex = /(#{expressions.join(".*?")}.*?\n)/m
      split_fragments_at split_regex
    end

    def remove_empty_lines_between_block_quote_lines
      @fragments = @fragments.collect do |fragment|
        if fragment.quoted?
          fragment.content = fragment.content.gsub /\n *?\n>/m, "\n>"
        end
        fragment
      end
    end

    def split_fragments_at(regex)
      @fragments = @fragments.collect do |fragment|
        if fragment.to_s
          first_text, *rest = fragment.to_s.split(regex)

          first_fragment = Fragment.new(false, first_text)
          first_fragment.quoted = fragment.quoted
          first_fragment.hidden = fragment.hidden
          first_fragment.signature = fragment.signature
          first_fragment.content = first_text

          hidden_fragment = Fragment.new(true, rest.join("\n"))
          hidden_fragment.content = rest.join("\n")

          hidden_fragment.quoted = true
          if @except_in_visible_block_quotes
            hidden_fragment.hidden = true unless fragment.quoted? and not fragment.hidden?
          else
            hidden_fragment.hidden = true
          end

          [first_fragment, hidden_fragment]
        end
      end.flatten - [nil]
      @fragments = @fragments.select { |fragment| fragment.to_s && fragment.to_s != "" }
    end

    def except_in_visible_block_quotes
      @except_in_visible_block_quotes = true
      yield
      @except_in_visible_block_quotes = false
    end

    private

    # Detects if a given line is a header above a quoted area.  It is only
    # checked for lines preceding quoted regions.
    #
    # line - A String line of text from the email.
    #
    # Returns true if the line is a valid header, or false.
    #
    # This method overrides the original in order to include the different
    # regex defined in the different ExtendedEmailReplyParser::Parsers.
    #
    def quote_header?(line)
      regex = ExtendedEmailReplyParser::Parsers::Base.quote_header_regexes.join("|")
      line.reverse =~ /#{regex}/
    end

  end
end