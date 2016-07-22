# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## master (unreleased)
### Security
### Added
- `Parsers::Base#hide_everything_after(expressions)` is useful when email clients do not quote the previous conversation. This parser method hides everything lead by a series of expressions, e.g. `hide_everything_after %w(From: Sent: To:)`.
- `Parsers::Base#except_in_visible_block_quotes`. Within this block, `hide_everything_after` is not applied. This is useful when a quote is already marked as to be shown.
- German parser `Parsers::I18nDe`, which identifies quotes by the phrases "Gesendet: Von: An:" and "Am ... schrieb ...:".
- Support for i18n-ed header lines. The github parser only knows "On ... wrote". Since this is needed when the github parser runs, specify additional regexes in the class header of the parsers using `add_quote_header_regex`, for example: `add_quote_header_regex '^Am .* schrieb.*$'`.

### Deprecated
### Removed
### Fixed

## ExtendedEmailReplyParser 0.1.0 (2016-07-22)
### Added
- `ExtendedEmailReplyParser.read "/path/to/email.eml"` returns the corresponding `Mail::Message` object.
- `ExtendedEmailReplyParser.read("/path/to/email.eml").extract_text` returns the email body text in utf-8. See also: http://stackoverflow.com/a/15818886/2066546
- Methods for parsing emails: `ExtendedEmailReplyParser.parse("/path/to/email.eml")`, `ExtendedEmailReplyParser.parse(message)`, `ExtendedEmailReplyParser.parse(body_text)`, `Mail::Message#parse`.
- Allowing to chain custom parsers. A parser inherits from `ExtendedEmailReplyParser::Parsers::Base` and needs to implement a `parse` method. The parser is automatically chained along with the others when calling `ExtendedEmailReplyParser.parse` or `MailMessage#parse`.
- Wrapping the original [github/email_reply_parser](https://github.com/github/email_reply_parser) in `ExtendedEmailReplyParser::Parsers::Github`.
