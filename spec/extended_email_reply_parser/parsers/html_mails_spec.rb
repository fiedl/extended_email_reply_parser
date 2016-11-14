# encoding: UTF-8
require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::HtmlMails do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse(@message) }

    describe "emails that have only a html part, no text part" do
      before { @message = Mail::Message.new(load_email('email_de_7')) }

      it 'does not include the html tag' do
        expect(subject).not_to include '<html'
      end
      it 'does not include the html closing tag' do
        expect(subject).not_to include '</html'
      end
      it 'does not include the body tag' do
        expect(subject).not_to include '<body'
      end
      it 'does not include the body closing tag' do
        expect(subject).not_to include '</body'
      end
      it 'includes some div tag' do
        expect(subject).to include '<div'
      end
    end

    describe "emails with <div name='quote'>" do
      before { @message = Mail::Message.new(load_email('email_de_7')) }

      it 'includes the relevant new reply text' do
        expect(subject).to include "die neuen Stati sehen auf der Plattform super aus und sind absolut richtig."
      end
      it 'does not include the previous conversation, lead by "Von: Gesendet: An:"' do
        expect(subject).not_to include "Betreff:"
        expect(subject).not_to include "ind beim ClzM drei mal Links zum Wintersemster 2016/2017. Leider kann"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "support@example.org"
        expect(subject).not_to include "Guten Tag!"
      end
    end

  end
end