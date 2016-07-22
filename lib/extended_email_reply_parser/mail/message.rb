# This extends the `Mail::Message` object of https://github.com/mikel/mail
# in order to allow:
#
#     (message.html_part || message.text_part || message).body_in_utf8
#
# See also: http://stackoverflow.com/a/15818886/2066546
#
module Mail
  class Message
    def body_in_utf8
      require 'charlock_holmes/string'
      body = self.body.decoded
      if body.present?
        encoding = body.detect_encoding[:encoding]
        body = body.force_encoding(encoding).encode('UTF-8')
      end
      return body
    end

    def extract_text
      (self.text_part || (self if self.content_type.include?('text/plain'))).body_in_utf8
    end

    def parse
      ExtendedEmailReplyParser.parse self
    end
  end
end