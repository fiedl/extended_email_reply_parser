module ExtendedEmailReplyParser
  class Parsers::Base

    attr_accessor :text

    def initialize(text_before_parsing)
      self.text = text_before_parsing
    end

    def parse
      return text
    end


    def self.subclasses
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
