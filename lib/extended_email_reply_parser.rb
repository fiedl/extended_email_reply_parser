require 'mail'

require 'extended_email_reply_parser/version'
module ExtendedEmailReplyParser

  # Read an email file and return a parsable `Mail::Message` object.
  #
  # Examples:
  #
  #     ExtendedEmailReplyParser.read "/path/to/email.eml"
  #     ExtendedEmailReplyParser.read("/path/to/email.eml").class   # => Mail::Message
  #
  def self.read(email_file_path)
    Mail.read email_file_path
  end

end
