require_relative 'spec_helper'

describe "Rabobank" do

  context "parse whole file" do
    let(:file_name) { File.dirname(__FILE__) + '/fixtures/14aug2014.swi' }
    let(:bank_statements) { MT940Structured::Parser.parse_mt940(file_name) }

    it "should have the correct number of bank account's" do
      bank_statements.keys.size.should == 1
    end

    it "should have the correct number of bank statements per bank account" do
      bank_statements["156750961"].size.should == 1
    end

    context MT940::BankStatement do
      let(:bank_statements_for_account) { bank_statements["156750961"] }

      it "should have the correct number of transactions per bank statement" do
        bank_statements_for_account[0].transactions.size.should == 2
      end

      context "single bank statement" do
        let(:bank_statement) { bank_statements_for_account[0] }
        let(:transaction) { bank_statement.transactions[1] }

        it "should have a correct previous balance per statement" do
          transaction.contra_account_owner.should == "COMPANY B V"
          transaction.description.should == "2037 201407-323/201407-322/201407 -3 27/201406-309/201406-310"
        end

      end

    end
  end
end
