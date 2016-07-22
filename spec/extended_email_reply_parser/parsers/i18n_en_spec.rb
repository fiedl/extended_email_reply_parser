# encoding: UTF-8
require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::I18nEn do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse(@text) }

    describe "for emails with 'From: Sent: To:'" do
      before { @text = load_email 'email_de_6' }

      it { is_expected.to be_kind_of String }

      it 'includes the relevant new reply text' do
        expect(subject).to include "der Vorschlag von Thomas scheint mir am sinnvollsten sein."
      end
      it 'does not include the previous conversation, lead by "From: Sent: To:"' do
        expect(subject).not_to include "Dear all,"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "From: F, Thomas"
      end
    end

  end
end