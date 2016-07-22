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

  describe "#extract_text" do
    let(:path) { 'spec/email_fixtures/email_multipart.eml' }
    let(:message) { Mail.read(path) }
    subject { ExtendedEmailReplyParser.extract_text(argument) }

    describe "given an email path" do
      let(:argument) { path }
      it { is_expected.to be_kind_of String }
      it { is_expected.to eq "This is a multipart test, bro!" }
    end
    describe "given a Mail::Message" do
      let(:argument) { message }
      it { is_expected.to be_kind_of String }
      it { is_expected.to eq "This is a multipart test, bro!" }
    end
  end

  describe "#parse" do
    let(:path) { 'spec/email_fixtures/email_multipart.eml' }
    let(:message) { Mail.read(path) }
    let(:message_text) { message.extract_text }

    describe "given an email path" do
      subject { ExtendedEmailReplyParser.parse(path) }
      it { is_expected.to be_kind_of String }
      it { is_expected.to eq "This is a multipart test, bro!" }
    end
    describe "given a Mail::Message object" do
      subject { ExtendedEmailReplyParser.parse(message) }
      it { is_expected.to be_kind_of String }
      it { is_expected.to eq "This is a multipart test, bro!" }
    end
    describe "given a mail body text string" do
      subject { ExtendedEmailReplyParser.parse(message_text) }
      it { is_expected.to be_kind_of String }
      it { is_expected.to eq "This is a multipart test, bro!" }
    end
  end
end
