class EmailReplyParser
  class Email
    def hide_everything_after(expressions)
      split_regex = /(#{expressions.join(".*?")}.*?\n)/m
      split_fragments_at split_regex
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
            hidden_fragment.hidden = true

          [first_fragment, hidden_fragment]
        end
      end.flatten - [nil]
      @fragments = @fragments.select { |fragment| fragment.to_s && fragment.to_s != "" }
    end
  end
end