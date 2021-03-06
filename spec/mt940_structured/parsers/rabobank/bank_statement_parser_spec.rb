require 'spec_helper'

describe MT940Structured::Parsers::BankStatementParser do

  let(:transaction_parsers) { MT940Structured::Parsers::Rabobank::TransactionParsers.new }
  subject { MT940Structured::Parsers::BankStatementParser.new("Rabobank", transaction_parsers, lines).bank_statement }

  context "structured" do
    let(:lines) do
      [
          ":25:NL50RABO0123456789",
          ":28C:0",
          ":60F:C130402EUR000000001147,95",
          ":61:130403D000000000127,50N102EREF NL96RBOS0523149468",
          ":86:/EREF/02-04-2013 22:56 1120000153447185/BENM//NAME/Nespresso Nede rland B.V./REMI/674725433 1120000153447185 14144467636004962 /ISDT/2013-04-03",
          ":62F:C130404EUR000000018846,34"
      ]
    end
    it { should be_kind_of(MT940::BankStatement) }
    its(:bank_account) { should eq "123456789" }
    its(:bank_account_iban) { should eq("NL50RABO0123456789") }
    its(:previous_balance) { should eq(MT940::Balance.new(1147.95, Date.new(2013, 4, 2), "EUR")) }
    its(:new_balance) { should eq(MT940::Balance.new(18846.34, Date.new(2013, 4, 4), "EUR")) }

    it "has 1 transaction" do
      expect(subject.transactions).to have(1).item
      expect(subject.transactions.first).to be_kind_of MT940::Transaction
    end
  end


end
