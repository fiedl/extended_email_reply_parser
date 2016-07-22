require 'spec_helper'

describe ExtendedEmailReplyParser do
  it 'has a version number' do
    expect(ExtendedEmailReplyParser::VERSION).not_to be nil
  end

  describe "#read" do
    subject { ExtendedEmailReplyParser.read('spec/email_fixtures/email_de_1.txt') }

    it { is_expected.to be_kind_of Mail::Message }
  end
end
