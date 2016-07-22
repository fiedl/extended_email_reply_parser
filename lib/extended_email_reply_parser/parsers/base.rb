module ExtendedEmailReplyParser
  class Parsers::Base

    attr_accessor :text

    def initialize(text_before_parsing)
      self.text = text_before_parsing
      @email = EmailReplyParser::Email.new.read(text)
    end

    def parse
      return text
    end


    def hide_everything_after(expressions)
      @email.hide_everything_after(expressions)
      return @email.visible_text
    end

    def self.subclasses
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
