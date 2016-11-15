require 'mail'
require 'charlock_holmes'
require 'email_reply_parser'
require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

require 'extended_email_reply_parser/mail/message'
require 'extended_email_reply_parser/email_reply_parser/email'
require 'extended_email_reply_parser/email_reply_parser/fragment'

require 'extended_email_reply_parser/parsers'
require 'extended_email_reply_parser/parsers/base'
Dir.glob(File.dirname(File.absolute_path(__FILE__)) + "/extended_email_reply_parser/parsers/*") { |file| require file }

require 'extended_email_reply_parser/version'

# Usage:
#
#     ExtendedEmailReplyParser.parse "/path/to/email.eml"
#     ExtendedEmailReplyParser.parse mail_message
#     ExtendedEmailReplyParser.parse MyReplyModel.find(123).text_content
#
module ExtendedEmailReplyParser

  # Read an email file and return a parsable `Mail::Message` object.
  # `Mail::Message` is defined in https://github.com/mikel/mail and
  # slightly extended in this gem.
  #
  # Examples:
  #
  #     ExtendedEmailReplyParser.read "/path/to/email.eml"
  #     ExtendedEmailReplyParser.read("/path/to/email.eml").parse
  #     ExtendedEmailReplyParser.read("/path/to/email.eml").class   # => Mail::Message
  #
  # or, maybe, you are looking for this:
  #
  #     ExtendedEmailReplyParser.parse "/path/to/email.eml"
  #
  def self.read(email_file_path)
    Mail.read email_file_path
  end

  # Extract the body text from the given Mail::Message.
  #
  #     ExtendedEmailReplyParser.extract_text message
  #     ExtendedEmailReplyParser.extract_text '/path/to/email.eml'
  #
  # This is the same as:
  #
  #     message.extract_text
  #
  def self.extract_text(message_or_path)
    if message_or_path.kind_of? Mail::Message
      message_or_path.extract_text
    elsif message_or_path.kind_of? String and File.file? message_or_path
      Mail.read(message_or_path).extract_text
    end
  end

  # Extract the body text from the given Mail::Message.
  # If there is no text part, extract the content of the body tag
  # of the html part.
  #
  #     ExtendedEmailReplyParser.extract_text_or_html message
  #     ExtendedEmailReplyParser.extract_text_or_html '/path/to/email.eml'
  #
  # This is the same as:
  #
  #     message.extract_text_or_html
  #
  def self.extract_text_or_html(message_or_path)
    if message_or_path.kind_of? Mail::Message
      message_or_path.extract_text_or_html
    elsif message_or_path.kind_of? String and File.file? message_or_path
      Mail.read(message_or_path).extract_text_or_html
    end
  end

  # This parses the given object, i.e. removes quoted replies etc.
  #
  # Examples:
  #
  #     ExtendedEmailReplyParser.parse "/path/to/email.eml"
  #     ExtendedEmailReplyParser.parse mail_message
  #     ExtendedEmailReplyParser.parse MyReplyModel.find(123).text_content
  #
  def self.parse(object)
    if object.kind_of? String and File.file? object
      self.parse_file object
    elsif object.kind_of? String
      self.parse_text object
    elsif object.kind_of? Mail::Message
      self.parse_message object
    end
  end

  def self.parse_file(file_path)
    self.parse_message Mail.read file_path
  end

  def self.parse_message(message)
    self.parse_text(message.extract_text_or_html)
  end

  def self.parse_text(text)
    parsed_text = text
    Parsers::Base.subclasses.each do |parser_class|
      parsed_text = parser_class.new(parsed_text).parse
    end
    parsed_text
  end

end
