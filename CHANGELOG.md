# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## master (unreleased)
### Security
### Added
- `ExtendedEmailReplyParser.read "/path/to/email.eml"` returns the corresponding `Mail::Message` object.
- `ExtendedEmailReplyParser.read("/path/to/email.eml").extract_text` returns the email body text in utf-8. See also: http://stackoverflow.com/a/15818886/2066546
- Methods for parsing emails: `ExtendedEmailReplyParser.parse("/path/to/email.eml")`, `ExtendedEmailReplyParser.parse(message)`, `ExtendedEmailReplyParser.parse(body_text)`, `Mail::Message#parse`.

### Deprecated
### Removed
### Fixed

