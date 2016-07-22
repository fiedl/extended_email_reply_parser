require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::Base do
  let(:email_text) { load_email('email_1_2') }
  let(:parser) { ExtendedEmailReplyParser::Parsers::Base.new(email_text) }

  describe "#parse" do
    subject { parser.parse }
    it 'does nothing by default and just returns the text' do
      expect(subject).to eq email_text
    end
  end
end