require 'spec_helper'

describe Mail::Message do

  describe "#extract_text" do
    describe "for multipart emails" do
      let(:message) { Mail.read('spec/email_fixtures/email_multipart.eml') }

      subject { message.extract_text }
      it { is_expected.to be_kind_of String }
      it 'should be utf-8 encoded' do
        expect(subject.encoding).to be Encoding::UTF_8
      end
      it 'extracts the body text' do
        expect(subject).to include 'This is a multipart test, bro!'
      end
      it 'does not extract the header' do
        expect(subject).not_to include "From: S F <S@example.com>"
      end
    end

    describe "for text emails" do
      let(:message) { Mail.read('spec/email_fixtures/email_text.eml') }

      subject { message.extract_text }
      it { is_expected.to be_kind_of String }
      it 'should be utf-8 encoded' do
        expect(subject.encoding).to be Encoding::UTF_8
      end
      it 'extracts the body text' do
        expect(subject).to include 'This is a text test, bro!'
      end
      it 'does not extract the header' do
        expect(subject).not_to include "From: S F <S@example.com>"
      end
    end
  end

  describe "#parse" do
    let(:message) { Mail.read('spec/email_fixtures/email_multipart.eml') }
    subject { message.parse }
    it { is_expected.to be_kind_of String }
  end

  describe "#from#first" do
    let(:message) { Mail.read('spec/email_fixtures/email_text.eml') }
    subject { message.from.first }
    it 'returns the email address' do
      expect(subject).to eq 'S@example.com'
    end
    it 'does not include the name' do
      expect(subject).not_to include "S F"
    end
  end
end