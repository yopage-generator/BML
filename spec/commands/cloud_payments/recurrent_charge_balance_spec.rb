require 'rails_helper'

describe CloudPayments::RecurrentChargeBalance, vcr: true do
  let(:account) { create :account, :with_payment_account, payment_token: payment_token, ident: 'root' }
  let!(:billing_account) { account.billing_account }
  let!(:amount)      { Money.new(5053, billing_account.amount_currency) }
  let!(:valid_token) { '2F725BBD1F405A1ED0336ABAF85DDFEB6902A9984A76FD877C3B5CC3B5085A82' }
  let!(:invalid_token) { 'ABBEF19476623CA56C17DA75FD57734DBF82530686043A6E491C6D71BEFE8F6E' }

  subject { described_class.new(account: account, amount: amount) }

  describe '#call' do
    context 'w/ valid params' do
      let(:payment_token) { valid_token }

      it 'must charge balance' do
        expect(Openbill.service).to receive(:make_transaction)
        subject.call
      end
    end

    context 'w/ banking errors (InvalidToken)' do
      let(:payment_token) { invalid_token }
      it 'must raise CloudPaymentsError' do
        expect { subject.call }.to raise_error(CloudPayments::Client::GatewayError)
      end
    end

    context 'Amount is greater than allowed' do
      let!(:amount) { Money.new(10_000_01, billing_account.amount_currency) }
      let(:payment_token) { valid_token }
      it 'must raise error' do
        expect { subject.call }.to raise_error CloudPayments::LargeAmountError
      end
    end
  end
end
