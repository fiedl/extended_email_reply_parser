# encoding: UTF-8
require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::I18nDe do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse(@text) }

    describe "for emails with inner block quotes" do
      before { @text = load_email 'email_de_1' }

      it { is_expected.to be_kind_of String }

      it 'includes the relevant text before the quote' do
        expect(subject).to include "die Ausgaben 3 und 4/2015 sowie 1/2016 wurden Cph. H wunschgemäß am 13.6.2016 zugesandt."
      end
      it 'includes the relevant text after the quote' do
        expect(subject).to include "Nun schreibt Cph. H mit Poststempel 5.7.2016"
      end
      it 'includes the block quote between relevant text' do
        expect(subject).to include "beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an"
      end
      it 'includes the header of the block quote' do
        expect(subject).to include "Am 12.06.2016 um 10:00 schrieb Wilhelm G. N"
      end
    end

    describe "emails with 'Von, Gesendet, An' ('From, Sent, To'), but without quote symbols (>)" do
      before { @text = load_email 'email_de_2' }

      it 'includes the relevant new reply text' do
        expect(subject).to include "ich hatte das bereits aktiviert"
      end
      it 'does not include the previous conversation, lead by "Von: Gesendet: An:"' do
        expect(subject).not_to include "Guten Tag!"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "support@example.org"
        expect(subject).not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler / Adreßänderungesmitteilungen / unbekannt verzogen"
      end
    end

    describe "emails with 'Von, An, Gesendet, Betreff', but without quote symbols '>'" do
      before { @text = @message = Mail::Message.new(load_email('email_de_8')) }

      it 'includes the relevant new reply text' do
        expect(subject).to include "Guten Abend"
        expect(subject).to include "Mein Profil, exampleitischer Lebenslauf"
        expect(subject).to include "Viele Grüße"
      end
      it 'does not include the previous conversation' do
        expect(subject).not_to include "Von:"
        expect(subject).not_to include "Betreff: Antwort: Meine Aktivitätszahlen stimmen nicht."
        expect(subject).not_to include "die verdrehten Aktivitätszahlen könnten eine Nachwehe unserer Wartungsarbeiten"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "support@example.org"
        expect(subject).not_to include "Antwort: Meine Aktivitätszahlen stimmen nicht."
      end
    end

    describe "emails with 'Gesendet, Vonn, An, Betreff', but without quote symbols '>'" do
      before { @text = @message = Mail::Message.new(load_email('email_de_9')) }

      it 'includes the relevant new reply text' do
        expect(subject).to include "Lieber ConPhil F"
        expect(subject).to include "vielen Dank f&uuml;r die R&uuml;ckmeldung"
        expect(subject).to include "Viele Gr&uuml;&szlig;e"
      end
      it 'does not include the previous conversation' do
        expect(subject).not_to include "Gesendet:"
        expect(subject).not_to include "Antwort: ich kann leider keine neue Ausgabe des Schoppenstechers"
        expect(subject).not_to include "Philister Back ist jetzt für zwei Wochen"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "support@example.org"
        expect(subject).not_to include "Antwort: ich kann leider keine neue Ausgabe des Schoppenstechers"
      end
    end

    describe "emails with signature separated by _____________________________" do
      before { @text = load_email 'email_de_3' }

      it 'includes the relevant text' do
        expect(subject).to include "Mail an abgemeldete Abonnenten."
        expect(subject).to include "Grüßle - Thomas"
      end
      it 'does not include the signature' do
        expect(subject).not_to include "_____________________________"
        expect(subject).not_to include "Dr. Thomas F"
      end
      it 'does not include the previous conversation' do
        expect(subject).not_to include "Am 09.07.2016 um 14:03 schrieb"
        expect(subject).not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler"
      end
    end

    describe "emails with 'Am ... schrieb ...' ('On ... wrote')" do
      before { @text = load_email 'email_de_4' }

      it 'includes the relevant new reply text' do
        expect(subject).to include "Mail an abgemeldete Abonnenten."
        expect(subject).to include "Grüßle - Thomas"
      end
      it 'does not include the previous conversation, lead by "Am ... schrieb ...:"' do
        expect(subject).not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler"
      end
      it 'does not include the header of the previous conversation' do
        expect(subject).not_to include "Am 09.07.2016 um 14:03 schrieb"
      end
    end

    describe "emails with 'Von, Gesendet, An' and, in the quotation, 'Am ... schrieb'" do
      before { @text = load_email 'email_de_5' }

      it 'includes the relevant new reply text' do
        expect(subject).to include "ich hatte das bereits aktiviert und war auch so im Profil erschienen."
      end
      it 'does not include the previous conversation, lead by "Von: Gesendet: An:"' do
        expect(subject).not_to include "Von: support@example.org"
        expect(subject).not_to include "Das Bild wurde vom Absender entfernt."
      end
      it 'does not include the previous conversation, lead by "Am ... schrieb ..."' do
        expect(subject).not_to include "Am 12.06.2016 um 10:00 schrieb Wilhelm G. N:"
        expect(subject).not_to include "beim Tübinger Kommers am Freitag sprach mich"
      end
    end

    describe "emails with empty lines between block qupte lines" do
      before { @text = load_email 'email_de_1' }
      it 'is removes those empty lines' do
        expect(subject).to include "> Lieber Reinke,\n>\n> beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an"
        expect(subject).not_to include "> Lieber Reinke,\n\n>\n\n> beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an"
      end
    end
  end
end