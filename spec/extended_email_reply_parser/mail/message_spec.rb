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
end