require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::Github do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse @text }

    describe "for email_1_2 of the original email_reply_parser" do
      before { @text = load_email 'email_1_2' }

      it { is_expected.to be_kind_of String }
      it 'includes the new reply text itself' do
        expect(subject).to include "Hi,"
      end
      it 'includes the new reply text, even after a quote' do
        expect(subject).to include "You can list the keys for the bucket and call delete for each."
      end
      it 'includes the quote if it is followed by unquoted text' do
        expect(subject).to include "> What is the best way to clear a Riak bucket of all key, values after"
      end
      it 'includes also the header line for the included quote' do
        expect(subject).to include "On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote:"
      end
      it 'does not include the quoted greeting, which is not followed by relevant text' do
        expect(subject).not_to include "-Abhishek Kona"
        expect(subject).not_to include "> -Abhishek Kona"
      end
      it 'does not include the mailing list footer' do
        expect(subject).not_to include "riak-users mailing list"
      end
    end

  end
end