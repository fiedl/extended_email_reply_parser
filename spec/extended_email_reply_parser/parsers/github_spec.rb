require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::Github do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse @text }

    describe "for email_1_2 of the original email_reply_parser" do
      before { @text = load_email 'email_1_2' }

      it { is_expected.to be_kind_of String }
      it { is_expected.to include "Hi," }
      it { is_expected.to include "On Tue, 2011-03-01 at 18:02 +0530, Abhishek Kona wrote:" }
      it { is_expected.to include "What is the best way to clear a Riak bucket of all key" }
      it { is_expected.to include "You can list the keys for the bucket and call delete for each." }
      it { is_expected.to include "At the moment there is no straightforward way to delete" }
      it { is_expected.not_to include "-Abhishek Kona" }
      it { is_expected.not_to include "riak-users mailing list" }
    end

  end
end