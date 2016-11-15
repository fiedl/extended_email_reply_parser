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
      (self.text_part || (self if self.content_type.include?('text/plain'))).try(:body_in_utf8)
    end

    def extract_html
      (self.html_part || (self if self.content_type.include?('text/html'))).try(:body_in_utf8)
    end

    def extract_text_or_html
      extract_text || extract_html_body_content
    end

    def extract_html_body_content
      # http://stackoverflow.com/a/356376/2066546
      extract_html.match(/(.*<\s*body[^>]*>)(.*)(<\s*\/\s*body\s*\>.+)/m)[2] || extract_html
    end

    def parse
      ExtendedEmailReplyParser.parse self
    end
  end
end