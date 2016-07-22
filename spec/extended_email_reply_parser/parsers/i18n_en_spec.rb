# encoding: UTF-8
require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::I18nEn do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse(@text) }

    describe "for emails with 'From: Sent: To:'" do
      before { @text = load_email 'email_de_6' }

      it { is_expected.to be_kind_of String }

      it { is_expected.to include "der Vorschlag von Thomas scheint mir am sinnvollsten sein." }
      it { is_expected.not_to include "From: F, Thomas" }
      it { is_expected.not_to include "Dear all," }
    end

  end
end