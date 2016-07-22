require 'spec_helper'

describe ExtendedEmailReplyParser do
  it 'has a version number' do
    expect(ExtendedEmailReplyParser::VERSION).not_to be nil
  end

  describe "#read" do
    subject { ExtendedEmailReplyParser.read('spec/email_fixtures/email_multipart.eml') }

    it { is_expected.to be_kind_of Mail::Message }
    it { is_expected.to respond_to :extract_text }
  end
end
