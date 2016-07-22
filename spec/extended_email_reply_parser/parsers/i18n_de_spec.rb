# encoding: UTF-8
require 'spec_helper'

describe ExtendedEmailReplyParser::Parsers::I18nDe do
  describe "#parse" do
    subject { ExtendedEmailReplyParser.parse(@text) }

    describe "for emails with inner block quotes" do
      before { @text = load_email 'email_de_1' }

      it { is_expected.to be_kind_of String }

      it { is_expected.to include "die Ausgaben 3 und 4/2015 sowie 1/2016 wurden Cph. H wunschgemäß am 13.6.2016 zugesandt." } # text before block quote
      it { is_expected.to include "Am 12.06.2016 um 10:00 schrieb Wilhelm G. N" } # inits the block quote
      it { is_expected.to include "beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an" } # block quote
      it { is_expected.to include "Nun schreibt Cph. H mit Poststempel 5.7.2016" } # text after block quote
    end

    describe "emails with 'Von, Gesendet, An' ('From, Sent, To'), but without quote symbols (>)" do
      before { @text = load_email 'email_de_2' }

      it { is_expected.to include "ich hatte das bereits aktiviert" } # text before block quote
      it { is_expected.not_to include "support@example.org" } # former reply header
      it { is_expected.not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler / Adreßänderungesmitteilungen / unbekannt verzogen" } # former reply header
      it { is_expected.not_to include "Guten Tag!" } # text in former reply
    end

    describe "emails with signature separated by _____________________________" do
      before { @text = load_email 'email_de_3' }

      it { is_expected.to include "Mail an abgemeldete Abonnenten." }
      it { is_expected.to include "Grüßle - Thomas" }
      it { is_expected.not_to include "Dr. Thomas F" }
      it { is_expected.not_to include "_____________________________" }
      it { is_expected.not_to include "Am 09.07.2016 um 14:03 schrieb" }
      it { is_expected.not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler" }
    end

    describe "emails with 'Am ... schrieb ...' ('On ... wrote')" do
      before { @text = load_email 'email_de_4' }

      it { is_expected.to include "Mail an abgemeldete Abonnenten." }
      it { is_expected.to include "Grüßle - Thomas" }
      it { is_expected.not_to include "Am 09.07.2016 um 14:03 schrieb" }
      it { is_expected.not_to include "Antwort: WBl 2-2016: Cph H erneut nicht im Verteiler" }
    end

    describe "emails with 'Von, Gesendet, An' and, in the quotation, 'Am ... schrieb'" do
      before { @text = load_email 'email_de_5' }

      it { is_expected.to include "ich hatte das bereits aktiviert und war auch so im Profil erschienen." }
      it { is_expected.not_to include "Von: support@example.org" }
      it { is_expected.not_to include "ich habe mir den Datensatz kurz angesehen." }
      it { is_expected.not_to include "Am 12.06.2016 um 10:00 schrieb Wilhelm G. N:" }
      it { is_expected.not_to include "beim Tübinger Kommers am Freitag sprach mich" }
    end

    describe "emails with empty lines between block qupte lines" do
      before { @text = load_email 'email_de_1' }
      it "is removes those empty lines" do
        expect(subject).to include "> Lieber Reinke,\n>\n> beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an"
        expect(subject).not_to include "> Lieber Reinke,\n\n>\n\n> beim Tübinger Kommers am Freitag sprach mich Cph. H darauf an"
      end
    end
  end
end