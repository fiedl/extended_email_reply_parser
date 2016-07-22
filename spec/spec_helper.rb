Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'pry'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'extended_email_reply_parser'

$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'spec/support/fixture_helper'
include FixtureHelper