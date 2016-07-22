require 'spec_helper'

describe ExtendedEmailReplyParser do
  it 'has a version number' do
    expect(ExtendedEmailReplyParser::VERSION).not_to be nil
  end

  describe "#read" do
    subject { ExtendedEmailReplyParser.read('spec/email_fixtures/email_multipart.eml') }

    it { is_expected.to be_kind_of Mail::Message }
    it { is_expected.to respond_to :extract_text }
    it { is_expected.to respond_to :parse }
  end

  describe "#parse" do
    let(:path) { 'spec/email_fixtures/email_multipart.eml' }
    let(:message) { Mail.read(path) }
    let(:message_text) { message.extract_text }

    describe "given an email path" do
      subject { ExtendedEmailReplyParser.parse(path) }
      it { is_expected.to be_kind_of String }
    end
    describe "given a Mail::Message object" do
      subject { ExtendedEmailReplyParser.parse(message) }
      it { is_expected.to be_kind_of String }
    end
    describe "given a mail body text string" do
      subject { ExtendedEmailReplyParser.parse(message_text) }
      it { is_expected.to be_kind_of String }
    end
  end
end
