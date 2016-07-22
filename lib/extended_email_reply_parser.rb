require 'mail'
require 'charlock_holmes'
require 'active_support'
require 'active_support/core_ext/object/blank'
require 'extended_email_reply_parser/mail/message'

require 'extended_email_reply_parser/version'
module ExtendedEmailReplyParser

  # Read an email file and return a parsable `Mail::Message` object.
  # `Mail::Message` is defined in https://github.com/mikel/mail and
  # slightly extended in this gem.
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
