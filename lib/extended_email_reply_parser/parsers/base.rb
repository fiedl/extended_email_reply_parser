module ExtendedEmailReplyParser
  class Parsers::Base
    @@quote_header_regexes ||= []

    attr_accessor :text

    def initialize(text_before_parsing)
      self.text = text_before_parsing
      @email = EmailReplyParser::Email.new.read(text)
    end

    def parse
      return text
    end

    def except_in_visible_block_quotes(&block)
      @email.except_in_visible_block_quotes(&block)
      return @email.visible_text
    end


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
    def self.add_quote_header_regex(regex_string)
      @@quote_header_regexes << regex_string
    end

    def self.subclasses
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
